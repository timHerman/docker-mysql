#!/bin/bash
set -e

INITIALIZED_FILE=/var/lib/mysql/INITIALIZED

echo >&2 "Init entrypoint"

if [ ! -f $INITIALIZED_FILE -a "${1%_safe}" = 'mysqld' ]; then
	if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
		export MYSQL_ROOT_PASSWORD=`apg -a 0 -m 15 | head -n 1`
		echo >&2 "Your generated root pwd: ${MYSQL_ROOT_PASSWORD}"
	fi

	if [ -z "$MYSQL_LOCAL_DATABASE" ]; then
		export MYSQL_LOCAL_DATABASE=`apg -a 0 -m 15 | head -n 1`
		echo >&2 "Your generated user pwd: ${MYSQL_LOCAL_DATABASE}"
	fi


	if [ -z "$MYSQL_LOCAL_USER" -o -z "$MYSQL_LOCAL_PASSWORD" -o -z "$MYSQL_LOCAL_DATABASE"  ]; then
		echo >&2 "Goodbye, you are the weakest link (No username, password and/or database defined)"
		exit 1
	fi

	mysql_install_db --datadir=/var/lib/mysql

	# These statements _must_ be on individual lines, and _must_ end with
	# semicolons (no line breaks or comments are permitted).
	# TODO proper SQL escaping on dat root password D:
	cat > /tmp/mysql-first-time.sql <<-EOSQL
                UPDATE mysql.user SET host = "%", password = PASSWORD("${MYSQL_ROOT_PASSWORD}") WHERE user = "root" LIMIT 1;
                DELETE FROM mysql.user WHERE user != "root" OR host != "%";
                CREATE DATABASE \`${MYSQL_LOCAL_DATABASE}\`;
                CREATE USER '${MYSQL_LOCAL_USER}'@'%' IDENTIFIED BY '${MYSQL_LOCAL_PASSWORD}';
                GRANT CREATE,INSERT,DELETE,UPDATE,SELECT on \`${MYSQL_LOCAL_DATABASE}\`.* to '${MYSQL_LOCAL_USER}'@'%';
                DROP DATABASE IF EXISTS test;
                FLUSH PRIVILEGES;
	EOSQL

	cat /tmp/mysql-first-time.sql

	touch $INITIALIZED_FILE

	chown -R mysql:mysql /var/lib/mysql
	exec "$@" --init-file=/tmp/mysql-first-time.sql
fi

chown -R mysql:mysql /var/lib/mysql
exec "$@"
