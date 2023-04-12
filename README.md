Docker configurations for Odoo Production environments
======================================================

START UP
=
- Enter odoo-x folder, with prompt

DOCKER COMPOSE
- Execute the next command: `docker compose up` (-d flag to execute in background)
- It will run the containers and show all the logs in the console.

STEP BY STEP
- `docker network create customNetwork`
- `docker run -d --name postgresql-prod --network customNetwork -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo -p 5432:5432 -v postgres-data-prod:/var/lib/postgresql/data --restart always postgres:14.0`
- `docker run -d --name postgresql-test --network customNetwork -e POSTGRES_USER=odoo -e POSTGRES_PASSWORD=odoo -p 35432:5432 -v postgres-data-test:/var/lib/postgresql/data --restart always postgres:14.0`
- `docker build -t odoo-prod odoo-prod`
- `docker run -d --name odoo-15-prod --network customNetwork -p 8069:8069 -p 8072:8072 -v odoo-data-prod:/opt/odoo --restart always -e DB_PORT_5432_TCP_ADDR=db-prod -e POSTGRES_HOST=postgresql-prod odoo-prod`
- `docker build -t odoo-test odoo-test`
- `docker run -d --name odoo-15-test --network customNetwork -p 8169:8069 -p 8172:8072 -v odoo-data-test:/opt/odoo --restart always -e DB_PORT_5432_TCP_ADDR=db-test -e POSTGRES_HOST=postgresql-test odoo-test`

DOCKER COMPOSE
=
- `docker compose down` Will rollback de docker compose up (except images and volumes)
- `docker compose up` Will build the docker compose file and will up the containers
- `docker compose build` Will build the docker compose

DOCKER CONTAINER
=
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

DOCKER IMAGES
=
- `docker images` List all images
- `docker image rm <image-name:version>` Remove image
- `docker build -t <image-name:tag> <path dockerfile>` Based on Dockerfile, build an image
- `docker pull <image-name:version>` Download an image

DOCKER NETWORKS
=
- `docker network ls` List all networks
- `docker network create <network-name>` Create a custom Network
- `docker network rm <network-name>` Removes the network

DOCKER VOLUMES
=
- `docker volume create <volume-name>` Create a volume
- `docker volume ls` List all volumes
- `docker volume inspect <volume-name>` Display detailed information on one or more volumes
- `docker volume rm <volume-name>` Remove one or more volumes
