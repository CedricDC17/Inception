#!/bin/bash
set -e

mkdir -p /run/php

cd /var/www/html

if [ ! -f wp-config.php ]; then

	DB_PASSWORD=$(cat /run/secrets/db_password)
	WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
	WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

	wp core download --allow-root

	wp config create --allow-root \
		--dbname="$DB_NAME" \
		--dbuser="$DB_USER" \
		--dbpass="$DB_PASSWORD" \
		--dbhost="$WP_DB_HOST"

	wp core install --allow-root \
		--url="https://$DOMAIN_NAME" \
		--title="$WP_TITLE" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--skip-email

	wp user create "$WP_USER_LOGIN" "$WP_USER_EMAIL" --allow-root \
		--role=subscriber \
		--user_pass="$WP_USER_PASSWORD"

fi

chown -R www-data:www-data /var/www/html

exec "$@"
