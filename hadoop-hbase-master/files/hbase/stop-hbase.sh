#!/bin/bash
hadoop_home=/usr/local/hbase
cd $hadoop_home
echo -e "stopping hbase \n"
./bin/stop-hbase.sh

echo -e "stopping local master beckup \n"
./bin/local-master-backup.sh stop
#The number at the end of the command signifies an offset that is added to the default
#ports of 60000 for RPC and 60010 for the web-based UI. In this example, a new master
#process would be started that reads the same configuration files as usual, but would
#listen on ports 60001 and 60011 , respectively.
echo -e "stopping local regionserver \n"

./bin/local-regionservers.sh stop
