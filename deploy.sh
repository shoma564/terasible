#!/bin/bash
echo "y" | docker system prune -a

docker-compose down --rmi all --volumes --remove-orphans

docker-compose down

docker-compose build

docker-compose up -d

echo "y" | docker system prune -a

docker ps | grep tera
