FROM amazonlinux

#VOLUME /Users/senguptag/Development/datastax /mnt/datastax/
# we can only specify the target mount point in container the source mount point cannot be
# specified and it remains to be seen using commands `docker volume ls`
WORKDIR /mnt

RUN yum install wget -y \
&& yum install htop -y \
&& yum install vim -y \
&& yum install tar -y \
&& yum install gzip -y \
&& yum install which -y \
&& yum install procps -y \
&& yum install git -y
#&& wget -c https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.tar.gz
#&& JAVA_HOME=/mnt/datastax/amazon-corretto-8.265.01.1-linux-x64/ /mnt/datastax/dse-6.8.3/bin/dse cassandra -s -g -k -R \
#&& JAVA_HOME=/mnt/datastax/amazon-corretto-8.265.01.1-linux-x64/ /mnt/datastax/datastax-studio-6.8.2/bin/server.sh