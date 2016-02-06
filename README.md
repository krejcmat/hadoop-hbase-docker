# hadoop-hbase-docker
Quickly build arbitrary size Hadoop Cluster based on Docker includes HBase database system
------
Core of this project is based on [kiwenlau](https://github.com/kiwenlau) and [Serf](https://github.com/jai11/docker-serf) docker file. Hadoop version is upgraded and its configuration is partly rewritten. In addition HBase support has been added. As UNIX system is used [Debian wheezy minimalistic](https://hub.docker.com/r/philcryer/min-wheezy/) instead of Ubuntu. Hadoop is setup as fully distributed cluster with YARN. As handler of HBase native Zookeeper is used. For large clusters is highly recomanded to use external Zookeeper management(not include). Size of docker images was reduced but but there is still room for optimizing. [Squash utility](https://github.com/jwilder/docker-squash) during optimization reduced only approx. 30Mb. The method is not used due to losing information of docker image layers. 

######Version of products
| system          | version    | 
| ----------------|:----------:| 
| Hadoop          | 2.71       |
| HBase           | 1.1.3      |
| Java            | JDK 7.60.19|

Used versions of Hadoop and HBase are officially compatible - fully tested.

######See file structure of project 
```
$ tree

.
├── build-image.sh
├── build.log
├── gitcommit.sh
├── hadoop-hbase-base
│   ├── Dockerfile
│   └── files
│       ├── bashrc
│       ├── hadoop-env.sh
│       ├── hbase-env.sh
│       └── ssh_config
├── hadoop-hbase-dnsmasq
│   ├── dnsmasq
│   │   ├── dnsmasq.conf
│   │   └── resolv.dnsmasq.conf
│   ├── Dockerfile
│   ├── handlers
│   │   ├── member-failed
│   │   ├── member-join
│   │   └── member-leave
│   └── serf
│       ├── event-router.sh
│       ├── serf-config.json
│       └── start-serf-agent.sh
├── hadoop-hbase-master
│   ├── Dockerfile
│   └── files
│       ├── hadoop
│       │   ├── configure-slaves.sh
│       │   ├── core-site.xml
│       │   ├── hdfs-site.xml
│       │   ├── mapred-site.xml
│       │   ├── run-wordcount.sh
│       │   ├── start-hadoop.sh
│       │   ├── start-ssh-serf.sh
│       │   ├── stop-hadoop.sh
│       │   └── yarn-site.xml
│       └── hbase
│           ├── hbase-site.xml
│           ├── start-hbase.sh
│           └── stop-hbase.sh
├── hadoop-hbase-slave
│   ├── Dockerfile
│   └── files
│       ├── hadoop
│       │   ├── core-site.xml
│       │   ├── hdfs-site.xml
│       │   ├── mapred-site.xml
│       │   ├── start-ssh-serf.sh
│       │   └── yarn-site.xml
│       └── hbase
│           └── hbase-site.xml
├── README.md
├── resize-cluster.sh
├── build-image.sh
└── start-container.sh


```

###Usage
####1] Clone git repository
```
$ git clone https://github.com/krejcmat/hadoop-hbase-docker.git
$ cd hadoop-hbase-docker
```

####2] Get docker images 
Two options how to get images are available. By pulling images directly from Docker official repository or build from Dockerfiles and sources files(see Dockerfile in each hadoop-hbase-* directory). Builds on DockerHub are automatically created by pull trigger or GitHub trigger after update Dockerfiles. Triggers are setuped for tag:latest. Below is example of stable version krejcmat/hadoop-hbase-<>:0.1. Version krejcmat/hadoop-hbase-<>:latest is compiled on DockerHub from master branche on GitHub.

######a) Download from Docker hub
```
$ docker pull krejcmat/hadoop-hbase-master:0.1
$ docker pull krejcmat/hadoop-hbase-slave:0.1
$ docker pull krejcmat/hadoop-hbase-base:0.1
$ docker pull krejcmat/hadoop-hbase-dnsmasq:0.1
```

######b)Build from sources(Dockerfiles)
The first argument of the script for bulilds is must be folder with Dockerfile. Tag for sources is **latest**
```
$ ./build-image.sh hadoop-hbase-dnsmasq
```

######Check images
```
$ docker images

krejcmat/hadoop-hbase-slave     0.1                 3618648042c7        58 minutes ago      1.09 GB
krejcmat/hadoop-hbase-master    0.1                 0e04fbcdd9fa        58 minutes ago      1.09 GB
krejcmat/hadoop-hbase-base      0.1                 e148f587cc4f        59 minutes ago      1.09 GB
krejcmat/hadoop-hbase-dnsmasq   0.1                 c4c4000322cf        About an hour ago   157.4 MB
philcryer/min-wheezy            latest              d196b785d987        14 months ago       50.76 MB
```
images:
philcryer/min-wheezy, krejcmat/hadoop-hbase-dnsmasq, krejcmat/hadoop-hbase-base are only temporary for builds. For removing use command:
```
$ docker rmi c4c4000322cf e148f587cc4f d196b785d987
``` 


####3] Initialize Hadoop (master and slaves)
######a)run containers
The first parameter of start-container.sh script is tag of image version, second parameter configuring number of nodes.
```
$ ./start-container.sh 0.1 2

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

Warning: Permanently added 'slave1.krejcmat.com,172.17.0.3' (ECDSA) to the list of known hosts.slaves          100%     40     0.0KB/s   00:00    
Warning: Permanently added 'slave1.krejcmat.com,172.17.0.3' (ECDSA) to the list of known hosts.slaves          100%     40     0.0KB/s   00:00    
Warning: Permanently added 'slave1.krejcmat.com,172.17.0.3' (ECDSA) to the list of known hosts.hbase-site.xml  100%   1730     1.7KB/s   00:00    
Warning: Permanently added 'master.krejcmat.com,172.17.0.2' (ECDSA) to the list of known hosts.slaves          100%     40     0.0KB/s   00:00    
Warning: Permanently added 'master.krejcmat.com,172.17.0.2' (ECDSA) to the list of known hosts.slaves          100%     40     0.0KB/s   00:00    
Warning: Permanently added 'master.krejcmat.com,172.17.0.2' (ECDSA) to the list of known hosts.hbase-site.xml  100%    1730    1.7KB/s  00:00    
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
starting resource manager, logging to /usr/local/hadoop/logs/yarn--resourcemanager-master.krejcmat.com.out
master.krejcmat.com: Warning: Permanently added 'master.krejcmat.com,172.17.0.2' (ECDSA) to the list of known hosts.
slave1.krejcmat.com: Warning: Permanently added 'slave1.krejcmat.com,172.17.0.3' (ECDSA) to the list of known hosts.
slave1.krejcmat.com: starting nodemanager, logging to /usr/local/hadoop/logs/yarn-root-nodemanager-slave1.krejcmat.com.out
master.krejcmat.com: starting nodemanager, logging to /usr/local/hadoop/logs/yarn-root-nodemanager-master.krejcmat.com.out
```

####3] Initialize Hbase database and run Hbase shell
######Start HBase
```
$ cd ~
$ ./start-hbase.sh

(hbase(main):001:0>)
```

######Check status
```
(hbase(main):001:0>)$ status

2 servers, 0 dead, 1.0000 average load
```
######Example of creating table and adding some values
```
$ create 'album','label','image'
```
Now you have a table called album, with a label, and an image family. These families are “static” like the columns in the RDBMS world.

Add some data:
```
$ put 'album','label1','label:size','10'
$ put 'album','label1','label:color','255:255:255'
$ put 'album','label1','label:text','Family album'
$ put 'album','label1','image:name','holiday'
$ put 'album','label1','image:source','/tmp/pic1.jpg'
```

Print table album,label1.
```
$get 'album','label1'

COLUMN                                              CELL
image:name                                          timestamp=1454590694743, value=holiday
image:source                                        timestamp=1454590759183, value=/tmp/pic1.jpg
label:color                                         timestamp=1454590554725, value=255:255:255
label:size                                          timestamp=1454590535642, value=10
label:text                                          timestamp=1454590583786, value=Family album
6 row(s) in 0.0320 seconds
```


####3]Control cluster from web UI
######Overview of UI web ports
| web ui           | port       |
| ---------------- |:----------:| 
| Hadoop namenode  | 50070      |
| Hadoop cluster   | 8088       |
| Hbase            | 60010      |


######Access from parent computer of docker container
Check IP addres in master container
```
$ ip a

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
4: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP 
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.2/16 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:acff:fe11:2/64 scope link 
       valid_lft forever preferred_lft forever

```
so your IP address is 172.17.0.2

```
$ xdg-open http://172.17.0.2:8088/
```
######Direct access from container(not implemented)
Used Linux distribution is installed without graphical UI. Easiest way is to use another Unix distribution by modifying Dockerfile of hadoop-hbase-dnsmasq and rebuild images. In this case start-container.sh script must be modified. On the line where the master container is created must add parameters for [X forwarding](http://wiki.ros.org/docker/Tutorials/GUI). 


###Documentation
####hadoop-hbase-dnsmasq
Base image for all the others. Dockerfile of dnsmaq provide image build based on Debian wheezy minimalistic and (Serf)[https://www.serfdom.io/] which is solution for cluster membership. Serf is also workaround for problem with  **/etc/hosts** which is readonly in docker containers. With starting docker container instance the reference is pass as: ```docker run -h -dns <IP_OF_DNS>```. Advantage of usage **Serf** is handling cluster, like nodes joining, leaving, failing. Configuration scripts are used from [Docker container Serf/Dnsmasq](https://github.com/jai11/docker-serf)


###Sources & references

######configuration
[Hadoop YARN installation guide](http://www.alexjf.net/blog/distributed-systems/hadoop-yarn-installation-definitive-guide/)

[Hbase main manual](https://hbase.apache.org/book.html)


######docker
[Docker cheat sheet](https://github.com/wsargent/docker-cheat-sheet)

[how to make docker image smaller](http://jasonwilder.com/blog/2014/08/19/squashing-docker-images/)


######HBase usage
[python wrapper for HBase rest API](http://blog.cloudera.com/blog/2013/10/hello-starbase-a-python-wrapper-for-the-hbase-rest-api/)

[usage of Java API for Hbase](https://autofei.wordpress.com/2012/04/02/java-example-code-using-hbase-data-model-operations/)

[Hbase shell commands](https://learnhbase.wordpress.com/2013/03/02/hbase-shell-commands/)

######Serf
[SERF: tool for cluster membership](https://www.serfdom.io/intro/)

[Serf docker presentation from Hadoop summit14](http://www.slideshare.net/JanosMatyas/docker-based-hadoop-provisioning)

[Docker Serf/Dnsmasq](https://github.com/jai11/docker-serf)

###Some notes, answers
######Region server vs datanode 
Data nodes store data. Region server(s) essentially buffer I/O operations; data is permanently stored on HDFS (that is, data nodes). I do not think that putting region server on your 'master' node is a good idea.

Here is a simplified picture of how regions are managed:

You have a cluster running HDFS (NameNode + DataNodes) with a replication factor of 3 (each HDFS block is copied into 3 different DataNodes).

You run RegionServers on the same servers as DataNodes. When write request comes to RegionServer it first writes changes into memory and commit log; then at some point, it decides that it is time to write changes to permanent storage on HDFS. Here is where data locality comes into play: since you run RegionServer and DataNode on the same server, first HDFS block replica of the file will be written to the same server. Two other replicas will be written to, well, other DataNodes. As a result, RegionServer serving the region will almost always have access to a local copy of data.

What if RegionServer crashes or RegionMaster decided to reassign region to another RegionServer (to keep cluster balanced)? New RegionServer will be forced to perform remote read first, but as soon as compaction is performed (merging of change log into the data) - new file will be written to HDFS by the new RegionServer, and local copy will be created on the RegionServer (again, because DataNode and RegionServer runs on the same server).

Note: in the case of RegionServer crash, regions previously assigned to it will be reassigned to multiple RegionServers.
