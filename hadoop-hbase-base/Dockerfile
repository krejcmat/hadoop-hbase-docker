FROM krejcmat/hadoop-hbase-dnsmasq:latest
MAINTAINER krejcmat <matejkrejci@gmail.com>

# install openssh-server, vim and openjdk
#$RUN apt-get update && \
#$apt-get install -y curl && \
#$apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y && \
#rm -rf /var/lib/{apt,dpkg,cache,log}/


#apt-get install -y openssh-server nano openjdk-7-jdk && \
#apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y && \
##rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
#rm -rf /tmp

# Java Version
ENV JAVA_VERSION_MAJOR 7
ENV JAVA_VERSION_MINOR 60
ENV JAVA_VERSION_BUILD 19
ENV JAVA_PACKAGE       jdk

# Download and unarchive Java
RUN apt-get update && \
apt-get install -y curl openssh-server nano && \
mkdir -p /opt &&\
    curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie"\
    http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz | gunzip -c - | tar -xf - -C /opt &&\
    ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /opt/jdk &&\
    rm -rf /opt/jdk/*src.zip \
         /opt/jdk/lib/missioncontrol \
         /opt/jdk/lib/visualvm \
         /opt/jdk/lib/*javafx* \
         /opt/jdk/jre/lib/plugin.jar \
         /opt/jdk/jre/lib/ext/jfxrt.jar \
         /opt/jdk/jre/bin/javaws \
         /opt/jdk/jre/lib/javaws.jar \
         /opt/jdk/jre/lib/desktop \
         /opt/jdk/jre/plugin \
         /opt/jdk/jre/lib/deploy* \
         /opt/jdk/jre/lib/*javafx* \
         /opt/jdk/jre/lib/*jfx* \
         /opt/jdk/jre/lib/amd64/libdecora_sse.so \
         /opt/jdk/jre/lib/amd64/libprism_*.so \
         /opt/jdk/jre/lib/amd64/libfxplugins.so \
         /opt/jdk/jre/lib/amd64/libglass.so \
         /opt/jdk/jre/lib/amd64/libgstreamer-lite.so \
         /opt/jdk/jre/lib/amd64/libjavafx*.so \
         /opt/jdk/jre/lib/amd64/libjfx*.so &&\
apt-get purge curl -y && apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y &&\
rm -rf /var/lib/{apt,dpkg,cache,log}/

# Set environment
ENV JAVA_HOME /opt/jdk
ENV PATH ${PATH}:${JAVA_HOME}/bin


# move all configuration files into container
ADD files/* /usr/local/  

# set jave environment variable 
ENV JAVA_HOME /opt/jdk 
ENV PATH $PATH:$JAVA_HOME/bin

#configure ssh free key access
RUN mkdir /var/run/sshd && \
ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
mv /usr/local/ssh_config ~/.ssh/config && \
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

#install hadoop 2.71
RUN wget -q -o /dev/null -P /tmp http://www.trieuvan.com/apache/hadoop/common/hadoop-2.7.1/hadoop-2.7.1.tar.gz && \
tar xzf /tmp/hadoop-2.7.1.tar.gz -C /usr/local && \
rm /tmp/hadoop-2.7.1.tar.gz && \
mv /usr/local/hadoop-2.7.1 /usr/local/hadoop && \
mv /usr/local/bashrc ~/.bashrc && \
mv /usr/local/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh

#install hbase 
RUN wget -q -o /dev/null -P /tmp http://www.eu.apache.org/dist/hbase/1.1.3/hbase-1.1.3-bin.tar.gz && \
tar xzf /tmp/hbase-1.1.3-bin.tar.gz -C /usr/local && \
rm /tmp/hbase-1.1.3-bin.tar.gz  && \
mv /usr/local/hbase-1.1.3 /usr/local/hbase && \
mv /usr/local/hbase-env.sh /usr/local/hbase/conf/hbase-env.sh 
