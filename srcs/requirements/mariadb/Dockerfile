FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y mariadb-server

RUN rm -rf /var/lib/mysql/*

COPY conf.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3306
ENTRYPOINT ["/entrypoint.sh"]
CMD ["mariadbd", "--user=mysql"]
