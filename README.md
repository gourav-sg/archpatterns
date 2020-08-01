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
 
# details 
* when we are archiving the files then we should have idempotency
* the operations should be stateless 
* we should be able to restore the data 
* we are not expecting that the archiving data is susceptible to changes. In case that happens then we are archving active records and restorations of records may make the system unstable
* when we are archiving a table which has entry in the metadata stores like HIVE metastores, etc, then this means we have to ensure that we remove the partition before deleting the data, otherwise if there is a partial delete then that partition will show partial data
* when we are archiving data we should not use move command for files, this is because in case the move command suddenly fails then the target location and the source location with both represent inconsistent states of the data 
* the ideal method should be to run something like sync instead of copy, so that the metadata of the files (like date of creation) is already maintained in the recycle bin
* when we are restoring the data we should have the option of specifying the particular lifecycle that we want to restore. Generally restoring the entire lifecycle may be a bad idea, we should also be able to say which particular location to restore to
* while restoring the storage class cannot change into incompatible types, for example we cannot restore data archived from S3 to Postgres database but we should be able to restore the data from S3 to S3  
* 

# code features 
* auto documentation
* PEP 8 