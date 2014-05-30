FROM ubuntu:trusty
MAINTAINER Takanobu Izukawa "takanobu@izukawa.org"

ENV MYSQL_USER admin
ENV MYSQL_PASS qwerty15

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg-divert --local --rename --add /sbin/initctl && rm -f /sbin/initctl && ln -s /bin/true /sbin/initctl

ADD sources.list /etc/apt/sources.list
ADD groonga.list /etc/apt/sources.list.d/groonga.list

RUN apt-get update -yq
RUN apt-get install -yq --allow-unauthenticated groonga-keyring
RUN apt-get update -yq && apt-get upgrade -yq
RUN apt-get install -yq mysql-server-mroonga groonga-tokenizer-mecab groonga-normalizer-mysql

ENV DEBIAN_FRONTEND dialog

ADD my.cnf /etc/mysql/my.cnf
ADD run.sh /run.sh
RUN chmod +x /run.sh

VOLUME ["/var/lib/mysql"]

EXPOSE 3306

CMD /run.sh
