#!/bin/bash

# run N slave containers
tag=$1
N=$2
SUDO=sudo

if [ $# \< 2 ]
then
	echo "Set first parametar as image version tag(e.g. 0.1) and second as number of nodes. Optional third parameter indicates NOT sudo."
	exit 1
fi

if [ $# -eq 3 ]
then
	SUDO=
fi

# delete old master container and start new master container
$SUDO docker rm -f master.krejcmat.com &> /dev/null
echo "start master container..."
$SUDO docker run -d -t --restart=always --dns 127.0.0.1 -P --name master.krejcmat.com -h master.krejcmat.com -w /root krejcmat/hadoop-hbase-master:$tag&> /dev/null

# get the IP address of master container
FIRST_IP=$(docker inspect --format="{{.NetworkSettings.IPAddress}}" master.krejcmat.com)

# delete old slave containers and start new slave containers
i=1
while [ $i -le $N ]
do
	$SUDO docker rm -f slave$i.krejcmat.com &> /dev/null
	echo "start slave$i container..."
	$SUDO docker run -d -t --restart=always --dns 127.0.0.1 -P --name slave$i.krejcmat.com -h slave$i.krejcmat.com -e JOIN_IP=$FIRST_IP krejcmat/hadoop-hbase-slave:$tag &> /dev/null
	((i++))
done


# create a new Bash session in the master container
$SUDO docker exec -it master.krejcmat.com bash
