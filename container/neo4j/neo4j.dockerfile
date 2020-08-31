FROM library/amazonlinux:latest

RUN cd /mnt && yum install wget -y && wget -c https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.tar.gz

CMD []

