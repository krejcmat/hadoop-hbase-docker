FROM krejcmat/serf-dnsmasq:0.1.0
MAINTAINER krejcmat <matejkrejci@gmail.com>

# init wheezy docker
RUN apt-get update && apt-get upgrade -y 
RUN pt-get clean -y && apt-get autoclean -y && apt-get autoremove -y
RUN cp -R /usr/share/locale/en\@* /tmp/ && rm -rf /usr/share/locale/* && mv /tmp/en\@* /usr/share/locale/
RUN rm -rf /var/cache/debconf/*-old && rm -rf /var/lib/apt/lists/* && rm -rf /usr/share/doc/*
RUN echo "`cat /etc/issue.net` Docker Image - philcryer/min-wheezy - `date +'%Y/%m/%d'`" > /etc/motd
RUN echo 'deb http://ftp.cz.debian.org/debian stable main contrib'>> /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y 

RUN apt-get update && \
apt-get install -y unzip curl dnsmasq

# dnsmasq configuration
ADD dnsmasq/* /etc/

# install serf
RUN curl -Lso serf.zip https://dl.bintray.com/mitchellh/serf/0.5.0_linux_amd64.zip && \
unzip serf.zip -d /bin && \
rm serf.zip

# configure serf
ENV SERF_CONFIG_DIR /etc/serf
ADD serf/* $SERF_CONFIG_DIR/
ADD handlers $SERF_CONFIG_DIR/handlers
RUN chmod +x  $SERF_CONFIG_DIR/event-router.sh $SERF_CONFIG_DIR/start-serf-agent.sh
