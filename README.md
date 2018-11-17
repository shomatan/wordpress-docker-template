# Docker compose: wordpress
Easy to build Wordpress theme development environment.  
The main theme and the root directory are synchronized.

## Features
- You don't have to install Nginx and PHP, MySQL.

## Requirements
- Docker
- Docker compose 1.22.0 (or later)

## Usage

### 1. Build a Docker image
    make build

### 2. Execute Wordpress
	make up

After you can acccess [http://localhost](http://localhost).  
If login, Username: `admin` Password: `admin`.

### 3. Stop Wordpress
    make stop

### 4. Remove all containers and delete volumes
    make destory

## Backup and restore

### Backup
	make backup

After creates a SQL file as ./backup/wordpress.sql

### Resotre
Restore wordpress database from ./backup/wordpress.sql

	make restore