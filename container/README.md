# CONTAINERS

the concept of architectures used to be different, but now it has been growing and merging with other fields like CI/CD.

Therefore understanding and implementing containers will be helpful.

## cloning aws image of ec2
we are trying to use EC2 images so that we can start working on getting these images to AWS
### reference
* https://docs.aws.amazon.com/AmazonECR/latest/userguide/amazon_linux_container_image.html
### steps
1. `docker pull amazonlinux`
1. `mkdir -p ~/Development/neo4j`
1. start docker container:
    * _container_: `docker run -it  --name neo4j --mount type=bind,source=$(cd ~; pwd)/Development/neo4j,target=/mnt/neo4j amazonlinux:latest /bin/bash`
    * _container_: `cd /mnt/neo4j`
    * _container_: `yum install wget -y`
    * _container_: `yum install vim -y` 
    * _local system_: downloaded latest version of neo4j manually in the system
    * _local system_: and then unzip them in the local system location which is mounted to the container
    * _local system_: `ln -s neo4j-community-4.1.1 neo4j`
    * _local system_: in the mount location `curl -LO https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.tar.gz`
    * _local system_: `untar amazon-corretto-11-x64-linux-jdk.tar.gz`
    * _container_: `ln -s amazon-corretto-11.0.8.10.1-linux-x64 java_11`
    * _container_: `echo "export JAVA_HOME=\"/mnt/neo4j/java_11\"" >> ~/.bash_profile ; source ~/.bash_profile`
1. came out of container, since all the dependencies are installed in the mounted area, therefore its not an issue
1. start the container: `docker start neo4j`
1. login to the container: `docker exec -it neo4j /bin/bash` or `docker attach neo4j`
1. stop the container after coming out of it: `docker stop neo4j`
1. we now need to create a new container with the ports mapped, note that as of now we cannot start a container whose ports were not mapped, and map new ports to them, or maybe I do not know about it
1. remove the local container: `docker run -it  --name neo4j --mount type=bind,source=$(cd ~; pwd)/Development/neo4j,target=/mnt/neo4j -p7474:7474 -p7687:7687 amazonlinux:latest /bin/bash`
1. start the container: `docker start neo4j`
1. get into the container:  `docker exec -it neo4j /bin/bash`
1. _container_ : `echo "export JAVA_HOME=\"/mnt/neo4j/java_11\"" >> ~/.bash_profile ; source ~/.bash_profile`
1. _container_ : `/mnt/neo4j/neo4j/bin/neo4j console`
1. At this point in time we can clearly see that though everything is set correctly we still cannot access the  
 

## DOCKER BASICS: VOLUME MOUNTING
* `docker run --rm -w /bin/ -v /tmp:/tmp amazonlinux /bin/bash -c "ls -las > /tmp/testoutput.txt"`
    * __-v__ mount volume in your host to volume in your guest
    * __-rm__ this starts a container from an image and then removes the container after the command execution is over
    * __-w__ this will change the working directory to `/bin` and therefore we do not have to run cd to that particular directory
* entering the option `--rm` at the end does not work `docker run -v /tmp:/tmp amazonlinux /bin/bash -c "ls -las > /tmp/testoutput.txt" --rm`

## DOCKER BASICS: PORT FORWARDING
* `docker run -d httpd`
    * __-d__ running in detached mode
    * __-p__ port binding `<<port in host>>`:`<<port in container>>`
        
* `docker logs <<container_name>> -f`
    * __-f__ shows the running logs of the container
* `docker inspect <<container name>>`, this shows the container configurations, and we can see the settings like `portbindings` or `ipaddress` and so on

# LEARNING PATH
* docker, dockerfile, docker compose: https://learning.oreilly.com/videos/docker-dockerfile-and/9781800206847
* try to see the video for Getting Started with Kubernetes LiveLessons, 2nd Edition by Sander available in Oreilly
* there is another course on Coursera for AWS: https://www.coursera.org/learn/containerized-apps-on-aws/
* there is another course for GCS: https://www.coursera.org/learn/google-kubernetes-engine
* and then the architecture patterns for GCS: https://www.coursera.org/specializations/architecting-google-kubernetes-engine
* Kubernetes up and running - https://learning.oreilly.com/library/view/kubernetes-up-and/9781492046523/


# REFERENCE
* https://docs.aws.amazon.com/AmazonECS/latest/developerguide/getting-started-fargate.html
* 
 