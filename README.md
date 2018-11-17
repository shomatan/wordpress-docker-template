# wordpress-docker-template

## Requirements
- Docker
- Docker compose 1.22.0 (or later)

## Usage

### 1. Build a Docker image
    make build

### 2. Run the wordpress
	make up

After you can acccess [http://localhost](http://localhost).  
If login, Username: `admin` Password: `admin`.

### 3. Stop wordpress
    make stop

### 4. Remove and delete volumes
    make destory

## Backup and restore

### Backup
	make backup

After creates a SQL file as ./backup/wordpress.sql

### Resotre
Restore wordpress database from ./backup/wordpress.sql

	make restore