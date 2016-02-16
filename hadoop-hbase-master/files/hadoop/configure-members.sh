#!/bin/bash

slaves=/tmp/slaves
rm -f $slaves
>$slaves
regionservers=/usr/local/hbase/conf/regionservers
rm -f $regionservers
>$regionservers
hbaseconf=/usr/local/hbase/conf/hbase-site.xml



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
                scp $slaves $member:$HADOOP_CONF_DIR/slaves #hadoop
                scp $slaves $member:$regionservers #hbase
                scp $hbaseconf $member:$hbaseconf #hbase
        done < "$slaves"
}


init_members
