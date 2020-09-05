# NEO4J

this is about creating a new neo4j container. And then use SPARK in order to work with the graph database


# CREATING THE CONTAINERS
* All details are given [here](https://github.com/datastax/graph-book/blob/master/docker-compose.yml)
* the datastax containers did not work out, therefore finally I downloaded all the JAVA files and docker files and unzipped and mounted them in a container
* currently I am running the Studio and Enterprise in the same container, later this can be changed - even this was causing issues therefore moved back to using the datastax containers and trying to fix the issue around quitting of dse 
* __this approach works finally__ : note that while I was trying to connect the datastax studio with the enterprise then connections were failing, that is container was quitting for dse. On order to avoid doing that, as soon as datastax enterprise started I logged into it with `docker exec -it <container name> /bin/bash `. And I was also monitoring the container with `docker logs <container name> -f` where the `-f` option is given to continue to stream the end of the logs. This solution does not make much sense, but still it works. Also I increased the memory for dockers to around 10GB, and restarted docker, this was done via docker desktop settings.
* __note__ : for the docker containers from datastax to work the above changes have been made








# FAQ
__?__ Why are we creating the container instead of downloading the container image ?
_A_: we want to use Amazon Linux container and therefore using this method. Also this gives us more autonomy  


# REFERENCE
* https://github.com/datastax/graph-book
* https://learning.oreilly.com/library/view/the-practitioners-guide 