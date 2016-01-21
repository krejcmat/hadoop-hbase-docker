#!/bin/bash

image=$1
tag="0.1.0"

if [ $# = 0 ]
then
	echo "Please use image name as the argument!"
	exit 1
fi


# founction for delete images
function docker_rmi()
{
	echo -e "\n\nsudo docker rmi kiwenlau/$1:$tag"
	sudo docker rmi kiwenlau/$1:$tag
}


# founction for build images
function docker_build()
{
	cd $1
	echo -e "\n\nsudo docker build -t kiwenlau/$1:$tag ."
	/usr/bin/time -f "real  %e" sudo docker build -t kiwenlau/$1:$tag .
	cd ..
}


echo -e "\ndocker rm -f slave1 slave2 master"
sudo docker rm -f slave1 slave2 master

sudo docker images >images.txt

if [ $image == "hadoop-hbase-dnsmasq" ]
then
	docker_rmi hadoop-hbase-master
	docker_rmi hadoop-hbase-slave
	docker_rmi hadoop-hbase-base
	docker_rmi hadoop-hbase-dnsmasq
	docker_build hadoop-hbase-dnsmasq
	docker_build hadoop-hbase-base
	docker_build hadoop-hbase-master
	docker_build hadoop-hbase-slave 
elif [ $image == "hadoop-hbase-base" ]
then
	docker_rmi hadoop-hbase-master
	docker_rmi hadoop-hbase-slave
	docker_rmi hadoop-hbase-base
	docker_build hadoop-hbase-base
	docker_build hadoop-hbase-master
	docker_build hadoop-hbase-slave
elif [ $image == "hadoop-hbase-master" ]
then
	docker_rmi hadoop-hbase-master
	docker_build hadoop-hbase-master
elif [ $image == "hadoop-hbase-slave" ]
then
	docker_rmi hadoop-hbase-slave
	docker_build hadoop-hbase-slave
else
	echo "The image name is wrong!"
fi

echo -e "\nimages before build"
cat images.txt
rm images.txt

echo -e "\nimages after build"
sudo docker images
