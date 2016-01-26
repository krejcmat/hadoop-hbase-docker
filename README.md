# in development !!
# hadoop-hbase-docker
Quickly build arbitrary size Hadoop Cluster based on Docker includes Hbase databse system
------

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

see file structure of project $ tree

```
.

├── hadoop-hbase-base
│   ├── Dockerfile
│   └── files
│       ├── bashrc
│       ├── hadoop-env.sh
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
│       ├── core-site.xml
│       ├── hdfs-site.xml
│       ├── mapred-site.xml
│       ├── run-wordcount.sh
│       ├── slaves
│       ├── start-hadoop.sh
│       ├── start-ssh-serf.sh
│       └── yarn-site.xml
├── hadoop-hbase-slave
│   ├── Dockerfile
│   └── files
│       ├── core-site.xml
│       ├── hdfs-site.xml
│       ├── mapred-site.xml
│       ├── start-ssh-serf.sh
│       └── yarn-site.xml
├── README.md
├── rebuild_hub.sh
├── resize-cluster.sh
└── start-container.sh
```


#### Links:
[HBASE-what is pseudo-distributed](http://archive.cloudera.com/cdh5/cdh/5/hbase-0.98.6-cdh5.3.4/book/standalone_dist.html)

[Hadoop YARN installation guide](http://www.alexjf.net/blog/distributed-systems/hadoop-yarn-installation-definitive-guide/)

[SERF: tool for cluster membership](https://www.serfdom.io/intro/)

[configuration hdfs-default.xml](https://hadoop.apache.org/docs/r2.7.1/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml)

[configuration mapred-default.xml](https://hadoop.apache.org/docs/r2.7.1/hadoop-mapreduce-client/hadoop-mapreduce-client-core/mapred-default.xml)

[configuration yarn-default.xml](https://hadoop.apache.org/docs/r2.7.1/hadoop-yarn/hadoop-yarn-common/yarn-default.xml)

[configuration core-site.xml](http://doc.mapr.com/display/MapR/Default+core+Parameters)

