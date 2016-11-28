FROM sebge2/hadoop-base:latest
MAINTAINER sgerard <sgerard@emasphere.com>

# move all configuration files into container
ADD files/* /usr/local/  

#install hbase 
RUN wget -q -o out.log -P /tmp http://www.eu.apache.org/dist/hbase/1.2.4/hbase-1.2.4-bin.tar.gz && \
tar xzf /tmp/hbase-1.2.4-bin.tar.gz -C /usr/local && \
rm /tmp/hbase-1.2.4-bin.tar.gz  && \
mv /usr/local/hbase-1.2.4 /usr/local/hbase && \
mv /usr/local/hbase-env.sh /usr/local/hbase/conf/hbase-env.sh  && \
mv /usr/local/bashrc ~/.bashrc
