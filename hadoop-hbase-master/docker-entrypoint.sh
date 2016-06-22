#!/bin/bash

echo "Start ssh and serf..."
/root/start-ssh-serf.sh

wait
echo "Configure members..."
/root/configure-members.sh

wait
echo "Start Hadoop..."
/root/start-hadoop.sh

wait
echo "Start HBase..."
/root/start-hbase.sh
