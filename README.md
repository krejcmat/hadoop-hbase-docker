# in development !!
# hadoop-hbase-docker
Quickly build arbitrary size Hadoop Cluster based on Docker includes Hbase database system
------

see file structure of project $ tree

```
├.
├── hadoop-hbase-base
│   ├── Dockerfile
│   └── files
│       ├── bashrc
│       ├── hadoop-env.sh
│       ├── hbase-env.sh
│       └── ssh_config
├── hadoop-hbase-dnsmasq
│   ├── dnsmasq
│   │   ├── dnsmasq.conf
│   │   └── resolv.dnsmasq.conf
│   ├── Dockerfile
│   ├── handlers
│   │   ├── member-failed
│   │   ├── member-join
│   │   └── member-leave
│   └── serf
│       ├── event-router.sh
│       ├── serf-config.json
│       └── start-serf-agent.sh
├── hadoop-hbase-master
│   ├── Dockerfile
│   └── files
│       ├── hadoop
│       │   ├── configure-slaves.sh
│       │   ├── core-site.xml
│       │   ├── hdfs-site.xml
│       │   ├── mapred-site.xml
│       │   ├── run-wordcount.sh
│       │   ├── start-hadoop.sh
│       │   ├── start-ssh-serf.sh
│       │   ├── stop-hadoop.sh
│       │   └── yarn-site.xml
│       └── hbase
│           ├── hbase-site.xml
│           └── start-hbase.sh
├── hadoop-hbase-slave
│   ├── Dockerfile
│   └── files
│       ├── hadoop
│       │   ├── core-site.xml
│       │   ├── hdfs-site.xml
│       │   ├── mapred-site.xml
│       │   ├── start-ssh-serf.sh
│       │   └── yarn-site.xml
│       └── hbase
│           └── hbase-site.xml
├── README.md
├── rebuild_hub.sh
├── resize-cluster.sh
├── build-image.sh
└── start-container.sh

```
####1] Clone git repository
```
$ git clone https://github.com/krejcmat/hadoop-hbase-docker.git
$ cd hadoop-hbase-docker
```

####2] Get docker images 
Two options how to get images are available. By pullig images directly from Doceker official repository or build from Dockerfiles and sources files(see Dockerfile in each hadoop-hbase-* directory). Builds on DockerHub are automatically created by pull trigger or GitHub trigger after update Dockerfiles. Due to quees on DockerHub is recomanded to build images localy( b)Build from sources).

######a) Download from Docker hub
```
$ docker pull krejcmat/hadoop-hbase-master:latest
$ docker pull krejcmat/hadoop-hbase-slave:latest
$ docker pull krejcmat/hadoop-hbase-base:latest
$ docker pull krejcmat/hadoop-hbase-dnsmasq:latest
```

######b)Build from sources(Dockerfiles)
```
$ ./build-image.sh hadoop-hbase-dnsmasq
```

######Check images
```
$ docker images

krejcmat/hadoop-hbase-slave         latest              4b0138d7210b        4 hours ago         905.2 MB
krejcmat/hadoop-hbase-master        latest              6117989f30c5        4 hours ago         905.2 MB
krejcmat/hadoop-hbase-base          latest              dccf08d8af07        5 hours ago         905.2 MB
krejcmat/hadoop-hbase-dnsmasq       latest              83bf3244df96        6 hours ago         147.9 MB
```

####3] Initialize Hadoop (master and slaves)
######a)run containers
start-container.sh script has parameter for configure number of nodes(default is 4) 

```
$ ./start-container.sh 2

start master container...
start slave1 container...
```

#####Check status
######Check members of cluster
```
$ serf members

master.krejcmat.com  172.17.0.2:7946  alive  
slave1.krejcmat.com  172.17.0.3:7946  alive
```

######Print Java processes
```
$ jps

342 NameNode
460 DataNode
1156 Jps
615 SecondaryNameNode
769 ResourceManager
862 NodeManager
```

######Print status of Hadoop cluster 
```
$ hdfs dfsadmin -report

Name: 172.17.0.2:50010 (master.krejcmat.com)
Hostname: master.krejcmat.com
Decommission Status : Normal
Configured Capacity: 98293264384 (91.54 GB)
DFS Used: 24576 (24 KB)
Non DFS Used: 77983322112 (72.63 GB)
DFS Remaining: 20309917696 (18.92 GB)
DFS Used%: 0.00%
DFS Remaining%: 20.66%
Configured Cache Capacity: 0 (0 B)
Cache Used: 0 (0 B)
Cache Remaining: 0 (0 B)
Cache Used%: 100.00%
Cache Remaining%: 0.00%
Xceivers: 1
Last contact: Wed Feb 03 16:09:14 UTC 2016

Name: 172.17.0.3:50010 (slave1.krejcmat.com)
Hostname: slave1.krejcmat.com
Decommission Status : Normal
Configured Capacity: 98293264384 (91.54 GB)
DFS Used: 24576 (24 KB)
Non DFS Used: 77983322112 (72.63 GB)
DFS Remaining: 20309917696 (18.92 GB)
DFS Used%: 0.00%
DFS Remaining%: 20.66%
Configured Cache Capacity: 0 (0 B)
Cache Used: 0 (0 B)
Cache Remaining: 0 (0 B)
Cache Used%: 100.00%
Cache Remaining%: 0.00%
Xceivers: 1
Last contact: Wed Feb 03 16:09:14 UTC 2016
```

#####b)Run Hadoop cluster
######Creating configures file for Hadoop and Hbase(includes zookeeper)
```
$ cd ~
$ ./configure-slaves.sh

Starting namenodes on [master.krejcmat.com]
master.krejcmat.com: Warning: Permanently added 'master.krejcmat.com,172.17.0.2' (ECDSA) to the list of known hosts.
master.krejcmat.com: starting namenode, logging to /usr/local/hadoop/logs/hadoop-root-namenode-master.krejcmat.com.out
slave1.krejcmat.com: Warning: Permanently added 'slave1.krejcmat.com,172.17.0.3' (ECDSA) to the list of known hosts.
master.krejcmat.com: Warning: Permanently added 'master.krejcmat.com,172.17.0.2' (ECDSA) to the list of known hosts.
slave1.krejcmat.com: starting datanode, logging to /usr/local/hadoop/logs/hadoop-root-datanode-slave1.krejcmat.com.out
master.krejcmat.com: starting datanode, logging to /usr/local/hadoop/logs/hadoop-root-datanode-master.krejcmat.com.out
Starting secondary namenodes [0.0.0.0]
0.0.0.0: Warning: Permanently added '0.0.0.0' (ECDSA) to the list of known hosts.
0.0.0.0: starting secondarynamenode, logging to /usr/local/hadoop/logs/hadoop-root-secondarynamenode-master.krejcmat.com.out

starting yarn daemons
starting resourcemanager, logging to /usr/local/hadoop/logs/yarn--resourcemanager-master.krejcmat.com.out
master.krejcmat.com: Warning: Permanently added 'master.krejcmat.com,172.17.0.2' (ECDSA) to the list of known hosts.
slave1.krejcmat.com: Warning: Permanently added 'slave1.krejcmat.com,172.17.0.3' (ECDSA) to the list of known hosts.
slave1.krejcmat.com: starting nodemanager, logging to /usr/local/hadoop/logs/yarn-root-nodemanager-slave1.krejcmat.com.out
master.krejcmat.com: starting nodemanager, logging to /usr/local/hadoop/logs/yarn-root-nodemanager-master.krejcmat.com.out
```

######Starting Hadoop
```
$ ./start-hadoop.sh 
 #For stop Hadoop ./stop-hadoop.sh

Starting namenodes on [master.krejcmat.com]
master.krejcmat.com: Warning: Permanently added 'master.krejcmat.com,172.17.0.2' (ECDSA) to the list of known hosts.
master.krejcmat.com: starting namenode, logging to /usr/local/hadoop/logs/hadoop-root-namenode-master.krejcmat.com.out
slave1.krejcmat.com: Warning: Permanently added 'slave1.krejcmat.com,172.17.0.3' (ECDSA) to the list of known hosts.
master.krejcmat.com: Warning: Permanently added 'master.krejcmat.com,172.17.0.2' (ECDSA) to the list of known hosts.
slave1.krejcmat.com: starting datanode, logging to /usr/local/hadoop/logs/hadoop-root-datanode-slave1.krejcmat.com.out
master.krejcmat.com: starting datanode, logging to /usr/local/hadoop/logs/hadoop-root-datanode-master.krejcmat.com.out
Starting secondary namenodes [0.0.0.0]
0.0.0.0: Warning: Permanently added '0.0.0.0' (ECDSA) to the list of known hosts.
0.0.0.0: starting secondarynamenode, logging to /usr/local/hadoop/logs/hadoop-root-secondarynamenode-master.krejcmat.com.out

starting yarn daemons
starting resourcemanager, logging to /usr/local/hadoop/logs/yarn--resourcemanager-master.krejcmat.com.out
master.krejcmat.com: Warning: Permanently added 'master.krejcmat.com,172.17.0.2' (ECDSA) to the list of known hosts.
slave1.krejcmat.com: Warning: Permanently added 'slave1.krejcmat.com,172.17.0.3' (ECDSA) to the list of known hosts.
slave1.krejcmat.com: starting nodemanager, logging to /usr/local/hadoop/logs/yarn-root-nodemanager-slave1.krejcmat.com.out
master.krejcmat.com: starting nodemanager, logging to /usr/local/hadoop/logs/yarn-root-nodemanager-master.krejcmat.com.out

```

####3] Initialize Hbase database and run Hbase shell
```
$ cd ~
$ ./start-hbase.sh
```





####Sources:
######general
[HBASE-what is pseudo-distributed](http://archive.cloudera.com/cdh5/cdh/5/hbase-0.98.6-cdh5.3.4/book/standalone_dist.html)

[SERF: tool for cluster membership](https://www.serfdom.io/intro/)

######configuration
[Hadoop YARN installation guide](http://www.alexjf.net/blog/distributed-systems/hadoop-yarn-installation-definitive-guide/)

[Hbase manual](https://hbase.apache.org/book.html)

[configuration hdfs-default.xml](https://hadoop.apache.org/docs/r2.7.1/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml)

[configuration mapred-default.xml](https://hadoop.apache.org/docs/r2.7.1/hadoop-mapreduce-client/hadoop-mapreduce-client-core/mapred-default.xml)

[configuration yarn-default.xml](https://hadoop.apache.org/docs/r2.7.1/hadoop-yarn/hadoop-yarn-common/yarn-default.xml)

[configuration core-site.xml](http://doc.mapr.com/display/MapR/Default+core+Parameters)

######docker
[how to make docker image smaller](http://jasonwilder.com/blog/2014/08/19/squashing-docker-images/)

######HBase db

[python wrapper for Hbase rest API](http://blog.cloudera.com/blog/2013/10/hello-starbase-a-python-wrapper-for-the-hbase-rest-api/)

[usage of Java API for Hbase](https://autofei.wordpress.com/2012/04/02/java-example-code-using-hbase-data-model-operations/)

[Hbase shell commands](https://learnhbase.wordpress.com/2013/03/02/hbase-shell-commands/)





#####NOTES
######Region server vs datanode 
Data nodes store data. Region server(s) essentially buffer I/O operations; data is permanently stored on HDFS (that is, data nodes). I do not think that putting region server on your 'master' node is a good idea.

Here is a simplified picture of how regions are managed:

You have a cluster running HDFS (NameNode + DataNodes) with replication factor of 3 (each HDFS block is copied into 3 different DataNodes).

You run RegionServers on the same servers as DataNodes. When write request comes to RegionServer it first writes changes into memory and commit log; then at some point it decides that it is time to write changes to permanent storage on HDFS. Here is were data locality comes into play: since you run RegionServer and DataNode on the same server, first HDFS block replica of the file will be written to the same server. Two other replicas will be written to, well, other DataNodes. As a result RegionServer serving the region will almost always have access to local copy of data.

What if RegionServer crashes or RegionMaster decided to reassign region to another RegionServer (to keep cluster balanced)? New RegionServer will be forced to perform remote read first, but as soon as compaction is performed (merging of change log into the data) - new file will be written to HDFS by the new RegionServer, and local copy will be created on the RegionServer (again, because DataNode and RegionServer runs on the same server).

Note: in case of RegionServer crash, regions previously assigned to it will be reassigned to multiple RegionServers.

