FROM sebge2/hadoop-hbase-base:latest
MAINTAINER sgerard <sgerard@emasphere.com>

# move all confugration /tmp into container
ADD files/hadoop/* /tmp/
ADD files/hbase/* /tmp/

ENV HADOOP_INSTALL /usr/local/hadoop

#RUN mkdir $HADOOP_INSTALL/logs

RUN mv /tmp/hdfs-site.xml $HADOOP_INSTALL/etc/hadoop/hdfs-site.xml && \
mv /tmp/core-site.xml $HADOOP_INSTALL/etc/hadoop/core-site.xml && \
mv /tmp/mapred-site.xml $HADOOP_INSTALL/etc/hadoop/mapred-site.xml && \
mv /tmp/yarn-site.xml $HADOOP_INSTALL/etc/hadoop/yarn-site.xml && \
mv /tmp/hbase-site.xml /usr/local/hbase/conf/hbase-site.xml

RUN mv /tmp/start-ssh-serf.sh ~/start-ssh-serf.sh && \
chmod +x ~/start-ssh-serf.sh

EXPOSE 22 7373 7946 9000 50010 50020 50070 50075 50090 50475 8030 8031 8032 8033 8040 8042 8060 8088 50060 2818 60000 60010

CMD '/root/start-ssh-serf.sh'; 'bash'

