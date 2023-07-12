DOCKER CONFIGURATIONS FOR ODOO PRODUCTION ENVIRONMENTS
======================================================

## Table of Contents
- [Installation](#installation)
    - [Pre-installation](#pre-installation)
    - [Docker installation](#docker-installation)
- [Start-up](#start-up)
    - [docker-compose](#docker-compose)
    - [Step by step](#step-by-step)
- [Backup](#backup)
    - [Prepare backup structure](#prepare-backup-structure)
    - [Stop services](#stop-services)
    - [Backup database](#backup-database)
    - [New odoo image](#new-odoo-image)
    - [Backup odoo](#backup-odoo)
    - [Start services](#start-services)
    - [Result](#result)
- [Restore](#restore)
    - [Enter backup folder](#enter-backup-folder)
    - [Create network](#create-network)
    - [Restore database](#restore-database)
    - [Create database container](#create-database-container)
    - [Restore odoo](#restore-odoo)
    - [Enable odoo image](#enable-odoo-image)
    - [Create odoo container](#create-odoo-container)
- [Useful commands](#useful-commands)
    - [Docker Compose](#docker-compose-commands)
    - [Docker Containers](#docker-container)
    - [Docker Images](#docker-images)
    - [Docker Networks](#docker-networks)
    - [Docker Volumes](#docker-volumes)

Installation
=
- ## Pre-installation
    - Update the OS

    <pre>
    sudo apt update
    </pre>

    - Install requirements
    <pre>
    sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
    </pre>

- ## Installation
    - Add GPT key of Docker repository
    <pre>
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    </pre>

    - Add Docker repository to the system
    <pre>
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    </pre>

    - Update packages to add Docker
    <pre>
    sudo apt update
    </pre>

    - Finally install Docker
    <pre>
    sudo apt install docker-ce
    </pre>

START UP
=

### DOCKER COMPOSE
- This command will mount the installation based on the docker compose file and it will show logs in the terminal (-d flag to execute in background).
<pre>
docker compose up
</pre>

### STEP BY STEP
- #### Create the network
<pre>
docker network create customNetwork
</pre>

- #### Run postgresql production container based on default image
<pre>
docker run -d --name postgresql-prod --network customNetwork -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo -p 5432:5432 -v postgres-data-prod:/var/lib/postgresql/data --restart always postgres:14.0
</pre>

- #### Run postgresql test container based on default image
<pre>
docker run -d --name postgresql-test --network customNetwork -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo -p 35432:5432 -v postgres-data-test:/var/lib/postgresql/data --restart always postgres:14.0
</pre>

- #### Create odoo production image based on the Dockerfile
<pre>
docker build -t odoo-prod odoo-prod
</pre>

- #### Create odoo test image based on the Dockerfile
<pre>
docker build -t odoo-test odoo-test
</pre>

- #### Run odoo production container based on odoo-prod image with some flags
<pre>
docker run -d --name odoo-15-prod --network customNetwork -p 8069:8069 -p 8072:8072 -v odoo-data-prod:/opt/odoo --restart always -e DB_PORT_5432_TCP_ADDR=db-prod -e POSTGRES_HOST=postgresql-prod odoo-prod
</pre>

- #### Run odoo test container based on odoo-test image with some flags
<pre>
docker run -d --name odoo-15-test --network customNetwork -p 8169:8069 -p 8172:8072 -v odoo-data-test:/opt/odoo --restart always -e DB_PORT_5432_TCP_ADDR=db-test -e POSTGRES_HOST=postgresql-test odoo-test
</pre>

BACKUP
=
### PREPARE BACKUP STRUCTURE

- `mkdir /tmp/backup-docker` Create a backup directory
- `cd /tmp/backup-docker` Enter the directory

### STOP SERVICES

- `docker stop <odoo-container-name>` Odoo service
- `docker stop <postgresql-container-name>` Postgresql service

### BACKUP DATABASE

- `docker run --rm --volumes-from <postgresql-container-name> -v $PWD:/tmp/backup-docker ubuntu tar cvf /tmp/backup-docker/<custom-postgresql-name>.tar /var/lib/postgresql/data` Backup the postgresql volume

### NEW ODOO IMAGE

- `docker export <odoo-container-name> > <custom-image-name-odoo>.tar` Create image based on a container

### BACKUP ODOO

- `docker run --rm --volumes-from <odoo-container-name> -v $PWD:/tmp/backup-docker ubuntu tar cvf /tmp/backup-docker/<custom-name-odoo>.tar /opt/odoo` Backup the odoo volume

### START SERVICES

- `docker start <postgresql-container-name>` Postgresql service (Wait for postgresql to start)
- `docker start <odoo-container-name>` Odoo service

### RESULT
- #### Now we have on /tmp/backup-docker folder
<pre>
- postgresql-test-data.tar
- odoo-15-test-img.tar
- odoo-15-test-data.tar
</pre>

RESTORE
=
### ENTER BACKUP FOLDER

- `cd /tmp/backup-docker` Enter the backup directory

### CREATE NETWORK

- `docker network create <network-name>` Create network to connect the containers

### RESTORE DATABASE

- `docker volume create <custom-postgresql-volume-name>` Create postgres database volume
- `docker run --rm -v <custom-postgresql-volume-name>:/var/lib/postgresql/data -v $PWD:/tmp/backup-docker ubuntu tar xvf /tmp/backup-docker/<custom-postgresql-name>.tar` Restore the postgresql volume

### CREATE DATABASE CONTAINER

- `docker run -d --name <postgresql-container-name> --network <network-name> -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo -p 35432:5432 -v <custom-postgresql-volume-name>:/var/lib/postgresql/data --restart always postgres:14.0` Create and run the backup postgresql container

### RESTORE ODOO

- `docker volume create <custom-odoo-volume-name>` Create odoo volume
- `docker run --rm -v <custom-odoo-volume-name>:/opt/odoo -v $PWD:/tmp/backup-docker ubuntu tar xvf /tmp/backup-docker/<custom-odoo-name>.tar` Restore the odoo volume

### ENABLE ODOO IMAGE

- `cat <exported-container-name>.tar | docker import --change 'CMD ["/opt/odoo/entrypoint.sh"]' - <custom-image-name-odoo>.tar` Create the odoo image, and add the entrypoint script

### CREATE ODOO CONTAINER

- `docker run -d --name <odoo-container-name> --network <network-name> -p 8169:8069 -p 8172:8072 -v <custom-odoo-volume-name>:/opt/odoo --restart always -e DB_PORT_5432_TCP_ADDR=db-test -e POSTGRES_HOST=<postgresql-container-name> <custom-image-name-odoo>.tar` Create and run the backup odoo container

USEFUL COMMANDS
=
### DOCKER COMPOSE COMMANDS

- `docker compose down` Will rollback de docker compose up (except images and volumes)
- `docker compose up` Will build the docker compose file and will up the containers
- `docker compose build` Will build the docker compose

### DOCKER CONTAINER
- `docker ps` Show running containers
- `docker ps -a` Show all containers
- `docker exec -it <container-name or id> bash` Opens the shell of the container
- `docker container rm <container-name or id>` Remove the specified container
- `docker create <image-name>` Create a container based on the image
- `docker create --name <container-name> <image-name>` Create a container with the specified name based on the image
- `docker create -p<client port>:<host port> <image-name>` Create a container with the specified ports forwarding
- `docker create -e <environment_variable-name=value> <image-name>` Create a container with the specifies environment variables
- `docker create –network <network-name>` Create a container inside the specified network
- `docker run <image-name:version>` Create a container with the specified image and show logs as –follow flag "ctrl + c" to stop container. Command workflow:
    - Find the image
    - If the image is not locally, it will downloaded
    - Create a container
    - Executes the container
- `docker run -d <image-name:version>` Create a container, but executes in background
- `docker start <container-id>` Execute a container
- `docker stop <container-id>` Stops the container
- `docker logs <container-id>` Show the logs of the specified container
- `docker logs –follow <container-id>` Show the logs of the container, and waits to get more logs

### DOCKER IMAGES
- `docker images` List all images
- `docker image rm <image-name:version>` Remove image
- `docker build -t <image-name:tag> <path dockerfile>` Based on Dockerfile, build an image
- `docker pull <image-name:version>` Download an image

### DOCKER NETWORKS
- `docker network ls` List all networks
- `docker network create <network-name>` Create a custom Network
- `docker network rm <network-name>` Removes the network

### DOCKER VOLUMES
- `docker volume create <volume-name>` Create a volume
- `docker volume ls` List all volumes
- `docker volume inspect <volume-name>` Display detailed information on one or more volumes
- `docker volume rm <volume-name>` Remove one or more volumes
