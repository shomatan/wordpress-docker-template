.DEFAULT_GOAL := help

DB_HOST=db
WP_USER=admin
WP_PASS=admin
WP_MAIL=wp@example123.com

build: ## Build a Docker image for wordpress 
	docker build docker/php -t wordpress-app

up: ## Execute wordpress
	docker-compose up -d
	@docker exec wordpress-db \
		bash -c ' \
			until echo \\'\q\\' | mysql -h $(DB_HOST) -u"root" -p"rootpassword" "wordpress" ; do \
				>&2 echo "**** MySQL is unavailable - sleeping" && \
				sleep 1; \
			done \
		'
	-@docker exec wordpress-app \
		sh -c ' \
			wp config create --path=/var/www/html --dbhost=$(DB_HOST) --dbname=wordpress --dbuser=wordpress --dbpass=wordpress --allow-root \
		'
	docker exec wordpress-app \
		sh -c ' \
			wp core install --url=localhost --title="Wordpress docker" --admin_user=$(WP_USER) --admin_password=$(WP_PASS) --admin_email=$(WP_MAIL) --allow-root \
		'

stop: ## Stop wordpress
	docker-compose stop

destroy: ## Remove and clean up wordpress
	docker-compose down -v

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'