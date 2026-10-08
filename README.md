*This activity has been created as part of the 42 curriculum by cedurget.*

# Inception

## Description

The Inception project is a WordPress site split into 3 containers (nginx / wordpress+php-fpm / mariadb), built from your own Dockerfiles on Debian bookworm, with 2 volumes, 1 network.

## Instructions

create the 4 password files in secrets/, add the line to /etc/hosts, make, then open the URL. 

```bash
mkdir -p secrets
echo "your_db_password"        > secrets/db_password.txt
echo "your_db_root_password"   > secrets/db_root_password.txt
echo "your_wp_admin_password"  > secrets/wp_admin_password.txt
echo "your_wp_user_password"   > secrets/wp_user_password.txt

echo "127.0.0.1 cedurget.42.fr" | sudo tee -a /etc/hosts
```

[cedurget.42.fr](cedurget.42.fr)

## Resources

- https://hub.docker.com/_/mariadb
- [mariadb custom image](https://mariadb.com/docs/server/server-management/automated-mariadb-deployment-and-administration/docker-and-mariadb/creating-a-custom-container-image)
- [youtube video explaining mariadb docker](https://www.youtube.com/watch?v=DQdB7wFEygo&t=48s&pp=ygUOZG9ja2VyIG1hcmlhZGI%3D)
- [nginx video](https://www.youtube.com/watch?v=RYTJPPsvvYE)

### Use of AI

- AI used me.
- explaining most concepts
- debug
- planning different steps

## Project description


### Virtual Machines vs Docker

### Secrets vs Environment Variables

### Docker Network vs Host Network

### Docker Volumes vs Bind Mounts

### Other design choices
