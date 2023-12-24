laravel sail:

- docker-compose up -d
- docker-compose down

to access laravel sail command go to ubuntu on windows
- wsl -d ubuntu
- sail up
- sail stop

then
- sail artisan migrate

web: http://127.0.0.1:8000/
email: http://127.0.0.1:8025/
 
____________________________________

to install docker create files
- Dockerfile
- docker-compose.yml

check files and view running images
- docker ps // all running images
- docker ps - a // all stopped images
- docker-compose ps

build docker compose
- docker-compose up --build

to run the docker in the background
- docker-compose up -d

to stop the docker
- docker-compose down
- docker-compose down && docker-compose up -d
- docker-compose down --volumes // to remove all volumes

to show all images
- docker images -a

to remove image by id
- docker rmi Image Image

to remove all images
- docker system prune
- docker system prune -a # remove stoped images only
- docker rmi $(docker images -a -q)

to access docker image file
-  docker exec -it laravel-docker-php-1 /bin/sh

add user to docker group do this command and restart the devices:
- sudo groupadd docker
- sudo usermod -aG docker $USER

