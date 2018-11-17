.DEFAULT_GOAL := help

DB_HOST=db
DB_USER=wordpress
DB_PASS=wordpress
DB_NAME=wordpress
WP_USER=admin
WP_PASS=admin
WP_MAIL=wp@example123.com

build: ## Build a Docker image for wordpress 
	docker build docker/php -t wordpress-app

up: ## Execute wordpress
	docker-compose up -d
	make wait-db
	-@docker exec wordpress-app \
		sh -c ' \
			wp config create --path=/var/www/html --dbhost=$(DB_HOST) --dbname=$(DB_HOST) --dbuser=$(DB_USER) --dbpass=$(DB_PASS) --allow-root \
		'
	docker exec wordpress-app \
		sh -c ' \
			wp core install --url=localhost --title="Wordpress docker" --admin_user=$(WP_USER) --admin_password=$(WP_PASS) --admin_email=$(WP_MAIL) --allow-root \
		'

stop: ## Stop wordpress
	docker-compose stop

destroy: ## Remove and clean up wordpress
	docker-compose down -v

.PHONY: backup
backup: ## Backup wordpress database. All containers will stop after backup.
	make up
	docker stop wordpress-web wordpress-app
	docker exec wordpress-db \
		bash -c ' \
			mysqldump -u $(DB_USER) -p$(DB_PASS) $(DB_NAME) > /backup/wordpress.sql \
		'
	make stop

restore: ## Restore wordpress database from ./backup/wordpress.sql . All containers will stop after restore.
	make up
	docker stop wordpress-web wordpress-app
	docker exec wordpress-db \
		bash -c ' \
			mysql -u $(DB_USER) -p$(DB_PASS) $(DB_NAME) < /backup/wordpress.sql \
		'
	make stop

wait-db:
	@docker exec wordpress-db \
		bash -c ' \
			until echo \\'\q\\' | mysql -h $(DB_HOST) -u"root" -p"rootpassword" "$(DB_NAME)" ; do \
				>&2 echo "**** MySQL is unavailable - sleeping" && \
				sleep 1; \
			done \
		'

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'