# NEO4J

this is about creating a new neo4j container. And then use SPARK in order to work with the graph database


# CREATING THE CONTAINERS
* we will have to first download the image for graph database from https://neo4j.com/download-center/#community, this is a manual process
* after this we download it to a particular location and unzip it 
* we then use docker compose to start the container as saved here
* note that we also download the docker container from neo4j because the port mappings were not working, and then opened the configuration file in their container and added ip address based lines to the open source download. This is primarily because of the way containers work specially in MAC in terms of its ip address. The lines added are:
    ```
    #********************************************************************
    # Other Neo4j system properties
    #********************************************************************
    #
    dbms.default_listen_address=0.0.0.0
    
    dbms.memory.pagecache.size=512M
    dbms.tx_log.rotation.retention_policy=100M size
    dbms.directories.plugins=/plugins
    dbms.directories.logs=/logs
    ```  
* if the docker-compose does not run, then we can run the following command `docker run -it  --name neo4jdb --mount type=bind,source=/Users/senguptag/Development/neo4j,target=/mnt/neo4j -p7474:7474 -p7687:7687 neo4j_neo4j /bin/bash`
* Your container immediately stops unless the commands are not running on foreground. Docker requires your command to keep running in the foreground. Otherwise, it thinks that your applications stops and shutdown the container.








# FAQ
__?__ Why are we creating the container instead of downloading the container image ?
_A_: we want to use Amazon Linux container and therefore using this method. Also this gives us more autonomy  


# REFERENCE
* https://learning.oreilly.com/library/view/graph-algorithms
* https://learning.oreilly.com/library/view/the-practitioners-guide 