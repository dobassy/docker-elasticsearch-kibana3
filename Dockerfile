FROM ubuntu:14.04
MAINTAINER D, Hiroki (ExLair) <exlair@gmail.com>

# localtime configuration
RUN echo "Asia/Tokyo" > /etc/timezone && dpkg-reconfigure tzdata
RUN rm -f /etc/localtime \
  && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# use mirror server in Japan
RUN sed -i -e 's/archive.ubuntu.com\/ubuntu\//ftp.jaist.ac.jp\/pub\/Linux\/ubuntu\//' /etc/apt/sources.list

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y upgrade \
  && apt-get install -y software-properties-common

# Basic Requirements
RUN apt-get -y install curl wget

ADD run.sh /run.sh
RUN chmod 705 /run.sh

#Installation
## Install Elasticsearch
RUN apt-get -y install openjdk-7-jdk


RUN mkdir -p /tmp/installation-els
RUN cd /tmp/installation-els \
  && wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.5.0.deb \
  && dpkg -i elasticsearch-1.5.0.deb

## Install Kibana
RUN mkdir -p /var/www/html
RUN cd /var/www/html \
  && wget https://download.elasticsearch.org/kibana/kibana/kibana-3.1.1.tar.gz \
  && tar zxvf kibana-3.1.1.tar.gz \
  && ln -s kibana-3.1.1 kibana \
  && chown -R www-data:www-data /var/www/html

RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update
RUN apt-get -y install nginx

# An apt files are cleaned
RUN rm -rf /var/lib/apt/lists/* \
  && apt-get clean

#EXPOSE 80
#EXPOSE 9200
CMD ["/bin/bash", "/run.sh"]
