# disclaimer
personal exercise, please feel free to indulge in confusion, chaos, and pure kicks in case you are using this.

# archpatterns
notes and practices from the book "Architecture Patterns with Python"


# used case
archiving files for tables 


# conceptual model

a table has many lifecycles, and a lifecycle can have multiple storage classes. The lifecycle and lifecycle storages can change over time. 

1. tables can be associated with classifications 
2. each table has a life lifecycle, for example:
    * onboarding (_raw_)
    * cleaned (_bronze_)
    * PK and FK updated with other tables (_silver_)
    * etc
3. each of these will be associated with different lifecycle storages, for example:
    * _onboarding_: hard disk/ HDFS/ S3/ Kafka/ etc
    * _bronze_: S3/ GS/ Postgres
    * _silver_: elasticsearch/ S3/ Delta
4. also each of these lifecycles may point to different storage types over time for example:
    * _bronze_ data may be stored from:
        * 01-Jan-2001 until 01-Jan-2010 in NFS mounted systems
        * 01-Jan-2010 until 01-Jan-2013 in HDFS (in AWS) 
        * 01-Jan-2013 until now in S3 (in AWS)
    
    we can see that the last two stages are both in AWS and all the new data exists in S3 where as the old data for the table exists in HDFS. This is ofcourse overloaded, and things might be simpler in real time
 
 # general process flow
 the tables are moved to the recyclebin and then deleted separately. The idea is that in case we want to restore the data we should be able to.
 
 when we are archiving a file then the entire lifecycles are first determined, and then we determine the order of these lifecycles. 
 
 Based on the order of the creation of these lifecycles, we determine the order in which the table will be archived. All the rules for determining the   
 
# details 
* the entire solution is being viewed as a DAG, in case there are cycling dependencies, things will cause severe inconsistencies and issues
* deletion dates are only determined either based on file creation date or partition date, if the deletion refers to column which is not the one based on which the table is partitioned, then the table has to be in delta or in database
* sub-partitions and their deletions is not covered initially 
* we should be able to validate after every run, whether separately running a program, or a new program whether the archival for a table has been done successfully or not
* removing lifecycle rules are not allowed, as they will help us understand the archival over several different years, archival rules which are not valid should have an end date based on the date when the data they point to stopped getting populated
* when we are archiving the files then we should have idempotency
* the operations should be stateless 
* we should be able to restore the data 
* we are not expecting that the archiving data is susceptible to changes. In case that happens then we are archving active records and restorations of records may make the system unstable
* when we are archiving a table which has entry in the metadata stores like HIVE metastores, etc, then this means we have to ensure that we remove the partition before deleting the data, otherwise if there is a partial delete then that partition will show partial data
* when we are archiving data we should not use move command for files, this is because in case the move command suddenly fails then the target location and the source location with both represent inconsistent states of the data 
* the ideal method should be to run something like sync instead of copy, so that the metadata of the files (like date of creation) is already maintained in the recycle bin
* when we are restoring the data we should have the option of specifying the particular lifecycle that we want to restore. Generally restoring the entire lifecycle may be a bad idea, we should also be able to say which particular location to restore to
* while restoring the storage class cannot change into incompatible types, for example we cannot restore data archived from S3 to Postgres database but we should be able to restore the data from S3 to S3  
* two different lifecycles cannot point to the same storage class, and location. For example, for table1 the lifecycle_raw and lifecycle_bronze cannot point to the database.user.table which are same. Or HDFS location which is the same
* if the storage is mentioned as glue, then we should:
    1. determine hte partition name from the description of the table 
    1. determine the storage location based on the partition determined by the date
    2. then the physical location of the table
    3. then create the table in SPARK for it, and then determine the partitions again
   
   This is because we can drop the partition first, and then while deleting the files we might fail midway, therefore next time around the only way to identify the partition would be to read the table definition from glue and then recreate a temporary table in SPARK which will load all the physical partitions.
* if the storage is just file location, and not delta then the date is basically the date of the file creation
* the storage is delta, then we obviously we need to:
    1. ensure that VACCUM has run to cover that date so that we do not have multiple files for that date
    2. sync the files to recycle bin
    3. then run the delete command in delta (which ever is the suitable command)
    4. in case we are creating athena / hive table metadata from delta that should also be updated accordingly
    5. all delta tables must have corresponding tables defined in Athena, in case they are not, then the location should be that of S3/ GCS/ HDFS



# how do we update the table.json file
firstly how do we what is the best option? 
    * Do we have a single json file with the name of all the tables in it, or 
    * do we have a single json file with different table names in it as dictionary?

currently we are choosing that there will be separate json files for each table. It looks bad and is not a great structure, but we can decide this later, in any case the changes required in the code for this kind of structure change will be minimum.


__table.json__
```json
"tablname": {
    "lifecycle_name_1": { "order" : 1},
    "lifecycle_name_2": {"order" : 2},
    "lifecycle_name_3": {"order" : 2},
}
```
* _note_ : we can have two lifecycles which are in the same level of order, think of this as a DAG 
    

looking at  the _lifecycle_ details for a table
```json
{
"tablname" : {
  "lifecycle_name_2" : {
                        "order" : 2,
                        "lifecycle_storage_name_2": { 
                                                      "storage": "delta",
                                                      "archival_type" : "table",
                                                      "archival_object_detail" : { "table_name": "table_name_in_glue"},
                                                      "starting_storage_date" : "01-Jan-2019",
                                                      "ending_storage_date" : "" or "21-Feb-2020"
                                                    },
                        "lifecycle_storage_name_1": { 
                                                      "storage": "glue",
                                                      "archival_object_type" : "table",
                                                      "archival_object_detail" : {"table_name": "table_name_in_glue" },
                                                      "starting_storage_date" : "01-Jan-2019",
                                                      "ending_storage_date" : "" or "21-Feb-2020"
                                                    },
  },
  "lifecycle_name_1" : {
                        "order" : 1,
                        "lifecycle_storage_name_1": { 
                                                      "storage": "s3",
                                                      "archival_object_type" : "file",
                                                      "archival_object_detail" : {
                                                                                    "bucket_name": "bucket_name",
                                                                                    "key_name": "keyname/table_file_name*.gz"
                                                                                  },
                                                      "starting_storage_date" : "01-Jan-2019",
                                                      "ending_storage_date" : "" or "21-Feb-2020"
                                                    },
  },

    "data_archive_before_period" : "month",
    "data_archive_before" : 2,
    "target_location_bucket" : "archive_bucket", 
    "target_location_key" : "/basepath/{tablename}/{lifecycle_name}/{lifecycle_storage_name}/{partition}/"

}
}
```

the json structure for the main program should include the following:
1. the location of storing all the logs of runs (*run files*)- these are not the logs of the run, but the logs of the actual runs that should happen. In case we are doing a dry run then only these files should be created, and nothing more, in actual runs the details from these files will be taken in and then executed in the physical layer. So this is generally the files which are used for handing over the actual archival payload. we should be able to use the logs of the run above and then compare the current system to understand how much of a run has been successful


# code features 
* auto documentation
* PEP 8 
* dry run 
* force run, to override the run files