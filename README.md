# hadoop-hbase-docker
Quickly build arbitrary size Hadoop Cluster based on Docker
------

#####a. pull image
```
docker pull krejcmat/hadoop-hbase-master:latest
docker pull krejcmat/hadoop-hbase-slave:latest
docker pull krejcmat/hadoop-hbase-base:latest
docker pull krejcmat/hadoop-hbase-dnsmasq:latest
```
*check downloaded images*

```
docker images
```



#### Links:
[configuration hdfs-default.xml](https://hadoop.apache.org/docs/r2.7.1/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml)
[configuration mapred-default.xml](https://hadoop.apache.org/docs/r2.7.1/hadoop-mapreduce-client/hadoop-mapreduce-client-core/mapred-default.xml)
[configuration yarn-default.xml](https://hadoop.apache.org/docs/r2.7.1/hadoop-yarn/hadoop-yarn-common/yarn-default.xml)

