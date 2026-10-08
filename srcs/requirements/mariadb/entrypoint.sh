#!/bin/bash
set -e

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -d /var/lib/mysql/mysql ]; then
	DB_PASSWORD=$(cat /run/secrets/db_password)
	DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

	mariadb-install-db --user=mysql --datadir=/var/lib/mysql --skip-test-db --auth-root-authentication-method=normal

	mariadbd --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;
DROP USER IF EXISTS 'root'@'$(hostname)';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD';
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF
fi

chown -R mysql:mysql /var/lib/mysql

exec "$@"
