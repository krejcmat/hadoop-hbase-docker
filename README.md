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
│       │   ├── master
│       │   ├── run-wordcount.sh
│       │   ├── start-hadoop.sh
│       │   ├── start-ssh-serf.sh
│       │   └── yarn-site.xml
│       └── hbase
│           └── hbase-site.xml
├── hadoop-hbase-slave
│   ├── Dockerfile
│   └── files
│       ├── hadoop
│       │   ├── core-site.xml
│       │   ├── hdfs-site.xml
│       │   ├── mapred-site.xml
│       │   ├── master
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


#####1] pull image
```
$ docker pull krejcmat/hadoop-hbase-master:latest
$ docker pull krejcmat/hadoop-hbase-slave:latest
$ docker pull krejcmat/hadoop-hbase-base:latest
$ docker pull krejcmat/hadoop-hbase-dnsmasq:latest
```

```
$ docker images

krejcmat/hadoop-hbase-slave         latest              4b0138d7210b        4 hours ago         905.2 MB
krejcmat/hadoop-hbase-master        latest              6117989f30c5        4 hours ago         905.2 MB
krejcmat/hadoop-hbase-base          latest              dccf08d8af07        5 hours ago         905.2 MB
krejcmat/hadoop-hbase-dnsmasq       latest              83bf3244df96        6 hours ago         147.9 MB
```


#####2] clone source code
```
$ git clone https://github.com/krejcmat/hadoop-hbase-docker.git
$ cd hadoop-hbase-docker
```

#####Print report of nodes 
```
$ hdfs dfsadmin -report
```

#### Sources:
#####General
[HBASE-what is pseudo-distributed](http://archive.cloudera.com/cdh5/cdh/5/hbase-0.98.6-cdh5.3.4/book/standalone_dist.html)

[SERF: tool for cluster membership](https://www.serfdom.io/intro/)

#####configuration
[Hadoop YARN installation guide](http://www.alexjf.net/blog/distributed-systems/hadoop-yarn-installation-definitive-guide/)

[configuration hdfs-default.xml](https://hadoop.apache.org/docs/r2.7.1/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml)

[configuration mapred-default.xml](https://hadoop.apache.org/docs/r2.7.1/hadoop-mapreduce-client/hadoop-mapreduce-client-core/mapred-default.xml)

[configuration yarn-default.xml](https://hadoop.apache.org/docs/r2.7.1/hadoop-yarn/hadoop-yarn-common/yarn-default.xml)

[configuration core-site.xml](http://doc.mapr.com/display/MapR/Default+core+Parameters)

######docker
[how to make docker image smaller](http://jasonwilder.com/blog/2014/08/19/squashing-docker-images/)

######HBase db
[python wrapper for HBASE rest API](http://blog.cloudera.com/blog/2013/10/hello-starbase-a-python-wrapper-for-the-hbase-rest-api/)
