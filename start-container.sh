#!/bin/bash

# run N slave containers
N=$1
tag="latest"
# the defaut node number is 3
if [ $# = 0 ]
then
	N=3
fi
	

# delete old master container and start new master container
sudo docker rm -f master &> /dev/null
echo "start master container..."
sudo docker run -d -t --dns 127.0.0.1 -P --name master -h master.krejcmat.com -w /root krejcmat/hadoop-hbase-master:latest&> /dev/null

# get the IP address of master container
FIRST_IP=$(docker inspect --format="{{.NetworkSettings.IPAddress}}" master)

# delete old slave containers and start new slave containers
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f slave$i &> /dev/null
	echo "start slave$i container..."
	sudo docker run -d -t --dns 127.0.0.1 -P --name slave$i -h slave$i.krejcmat.com -e JOIN_IP=$FIRST_IP krejcmat/hadoop-hbase-slave:latest &> /dev/null
	((i++))
done 


# create a new Bash session in the master container
sudo docker exec -it master bash
