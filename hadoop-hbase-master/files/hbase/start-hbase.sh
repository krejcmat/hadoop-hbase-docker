#!/bin/bash
hadoop_home=/usr/local/hbase
cd $hadoop_home
echo -e "starting hbase \n"
./bin/start-hbase.sh

#echo -e "starting local master beckup \n"
#./bin/local-master-backup.sh start 1
#The number at the end of the command signifies an offset that is added to the default
#ports of 60000 for RPC and 60010 for the web-based UI. In this example, a new master
#process would be started that reads the same configuration files as usual, but would
#listen on ports 60001 and 60011 , respectively.

#echo -e "starting local regionserver \n"
#./bin/local-regionservers.sh start 3
sleep 5
echo -e "starting hbase shell  \n"
./bin/hbase shell