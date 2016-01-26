#!/bin/bash

slaves=/tmp/slaves
hbaseconf=/usr/local/hbase/conf/hbase-site.xml
rm -f $slaves
touch  $slaves
function init_members(){
        members=$(serf members 2>&1| tac)
        while read -r line; do
                if [[ $line =~ "alive" ]]
                then
                        alive_mem=$(echo $line | cut -d " " -f 1 2>&1) #get hosts 
                        echo "$alive_mem">>$slaves
                        continue
                fi
        done <<< "$members"
        #copy slave file to all slaves and master
        #create hbase 
        members_line=$(paste -d, -s $slaves 2>&1)
        memstr='members' #uniq string for replace
        sed -i -e "s/$memstr/$members_line/g" $hbaseconf

        while read -r member
        do
                echo "copy $slaves "
                 scp $slaves $member:$HADOOP_CONF_DIR/slaves 
                 scp $hbaseconf $member:$hbaseconf
        done < "$slaves"
}


init_members
