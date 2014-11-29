FROM debian:latest

MAINTAINER Tim Herman <tim@belg.be>

RUN groupadd -r mysql && useradd -r -g mysql mysql
RUN apt-get update && apt-get install -y mysql-server apg

RUN sed -E -i -e 's/= 127.0.0.1/= 0.0.0.0/g' -e 's/^(\[mysqld\])/\1\ninnodb_use_native_aio=0/' /etc/mysql/my.cnf

WORKDIR /usr/local/mysql
VOLUME /var/lib/mysql

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3306

CMD ["mysqld", "--datadir=/var/lib/mysql", "--user=mysql"]
