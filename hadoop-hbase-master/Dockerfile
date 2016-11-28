FROM sebge2/hadoop-hbase-base:latest
MAINTAINER sgerard <sgerard@emasphere.com>

# move all configuration files into container
ADD files/hadoop/* /tmp/
ADD files/hbase/* /tmp/
ADD ./docker-entrypoint.sh /tmp/

ENV HADOOP_INSTALL /usr/local/hadoop

RUN mkdir -p ~/hdfs/namenode && \
mkdir -p ~/zookeeper && \ 
mkdir -p ~/hdfs/datanode

RUN mv /tmp/hdfs-site.xml $HADOOP_INSTALL/etc/hadoop/hdfs-site.xml && \ 
mv /tmp/core-site.xml $HADOOP_INSTALL/etc/hadoop/core-site.xml && \
mv /tmp/mapred-site.xml $HADOOP_INSTALL/etc/hadoop/mapred-site.xml && \
mv /tmp/yarn-site.xml $HADOOP_INSTALL/etc/hadoop/yarn-site.xml && \
mv /tmp/stop-hadoop.sh ~/stop-hadoop.sh && \
mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
mv /tmp/run-wordcount.sh ~/run-wordcount.sh && \ 
mv /tmp/start-ssh-serf.sh ~/start-ssh-serf.sh && \ 
mv /tmp/hbase-site.xml /usr/local/hbase/conf/hbase-site.xml -f && \
mv /tmp/configure-members.sh ~/configure-members.sh && \
mv /tmp/stop-hbase.sh ~/stop-hbase.sh && \
mv /tmp/start-hbase.sh ~/start-hbase.sh && \
mv /tmp/docker-entrypoint.sh ~/docker-entrypoint.sh

RUN chmod +x ~/start-hadoop.sh && \
chmod +x ~/run-wordcount.sh && \
chmod +x ~/start-ssh-serf.sh && \
chmod +x ~/docker-entrypoint.sh && \
chmod 1777 tmp

# format namenode
RUN /usr/local/hadoop/bin/hdfs namenode -format

EXPOSE 22 7373 7946 9000 50010 50020 50070 50075 50090 50475 8030 8031 8032 8033 8040 8042 8060 8088 50060 2818 60000 60010

CMD '/root/docker-entrypoint.sh'; 'bash'
