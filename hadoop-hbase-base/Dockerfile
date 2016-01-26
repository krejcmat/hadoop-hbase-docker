FROM krejcmat/hadoop-hbase-dnsmasq:latest
MAINTAINER krejcmat <matejkrejci@gmail.com>

# install openssh-server, vim and openjdk
RUN apt-get update
RUN apt-get install -y openssh-server vim wget
RUN apt-get install -y openjdk-7-jdk 

# move all configuration files into container
ADD files/* /usr/local/  

# set jave environment variable 
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64 
ENV PATH $PATH:$JAVA_HOME/bin

#configure ssh free key access
RUN mkdir /var/run/sshd && \
ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
mv /usr/local/ssh_config ~/.ssh/config && \
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

#install hadoop 2.71
RUN wget -q -o /dev/null -P /tmp http://www.trieuvan.com/apache/hadoop/common/hadoop-2.7.1/hadoop-2.7.1.tar.gz && \
tar vxzf /tmp/hadoop-2.7.1.tar.gz -C /usr/local && \
rm /tmp/hadoop-2.7.1.tar.gz && \
mv /usr/local/hadoop-2.7.1 /usr/local/hadoop && \
mv /usr/local/bashrc ~/.bashrc && \
mv /usr/local/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh 
mv /usr/local/hbase-env.sh /usr/local/hbase/conf/hbase-env.sh 

#install hbase 
RUN wget -q -o /dev/null -P /tmp http://www.eu.apache.org/dist/hbase/1.1.2/hbase-1.1.2-bin.tar.gz && \
tar vxzf /tmp/hbase-1.1.2-bin.tar.gz -C /usr/local && \
rm /tmp/hbase-1.1.2-bin.tar.gz  && \
mv /usr/local/hbase-1.1.2 /usr/local/hbase 

RUN apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y && \
rm -rf /var/lib/{apt,dpkg,cache,log}/