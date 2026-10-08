# Developer documentation

## Setup from scratch

### Prerequisites

- A Linux VM
- Docker and Docker Compose
- Being in the docker group or sudo

### Files to create

Four files must be created by hand in `secrets/` before the first start

```bash
mkdir -p secrets
echo "your_db_password"        > secrets/db_password.txt
echo "your_db_root_password"   > secrets/db_root_password.txt
echo "your_wp_admin_password"  > secrets/wp_admin_password.txt
echo "your_wp_user_password"   > secrets/wp_user_password.txt
```

### Configuration

Non-sensitive settings are in `srcs/.env`:

| Variable | Used by | Meaning |
|---|---|---|
| `DOMAIN_NAME` | nginx, wordpress | Site domain, also the certificate name |
| `DB_NAME` | mariadb, wordpress | Database to create |
| `DB_USER` | mariadb, wordpress | Database account used by WordPress |
| `WP_DB_HOST` | wordpress | Address of the database, `mariadb:3306` |
| `WP_TITLE` | wordpress | Site title |
| `WP_ADMIN_USER`, `WP_ADMIN_EMAIL` | wordpress | Administrator account |
| `WP_USER_LOGIN`, `WP_USER_EMAIL` | wordpress | Second account |

The domain is hardcoded in `srcs/requirements/nginx/nginx.conf` as well, nginx does not read environment variables.

Finally, make the domain resolve locally:

```bash
echo "127.0.0.1 cedurget.42.fr" | sudo tee -a /etc/hosts
```

## Build and launch

| Command | Effect |
|---|---|
| `make` (up) | Create the data folders, build the images, start the containers |
| `make down` | Stop and remove the containers, keep images and data |
| `make clean` | `down` plus delete the images |
| `make fclean` | `clean` plus delete the volumes and the data on the host |
| `make re` | `fclean` then start again from zero |
| `make list` | Show containers and images |
| `make acs TARGET=nginx` | Open a shell inside a container |

Startup order is handled by Docker: mariadb declares a healthcheck, and wordpress waits for it. nginx waits for wordpress to be created.

The first start takes longer: mariadb initializes the database and wordpress downloads WordPress.

## Manage containers and volumes

```bash
docker ps                      running containers
docker ps -a                   stopped ones too
docker images                  built images
docker exec -it mariadb bash   shell inside a container

docker volume ls               list volumes
docker volume inspect srcs_mariadb-data
docker network ls
docker network inspect srcs_inception

docker exec nginx cat /proc/1/comm          the daemon must be PID 1
docker exec mariadb mariadb -u root -p"$(cat secrets/db_root_password.txt)" -e "SHOW DATABASES;"  #displays the mariadb databases
docker exec wordpress wp user list --allow-root --path=/var/www/html #wp user list
```

Rebuild 1 service:

```bash
docker compose -f srcs/docker-compose.yml up -d --build nginx
```

## Data storage and persistence

Two named volumes hold everything that must survive:

| Volume | Mounted in | Host folder | Contains |
|---|---|---|---|
| `mariadb-data` | mariadb, at `/var/lib/mysql` | `/home/cedurget/data/mariadb` | The databases: posts, users, settings |
| `wordpress-data` | wordpress and nginx, at `/var/www/html` | `/home/cedurget/data/wordpress` | WordPress source files, `wp-config.php`, themes, plugins, uploads |

They are declared as named volumes with `driver_opts` so that Docker stores their data at the required path.

The folders must exist before the first start. Makefile makes sure they exist.

- Each entrypoint only initializes on the first start. mariadb checks `/var/lib/mysql/mysql`, wordpress checks `wp-config.php`. If those exist, setup is skipped and the existing data is reused.
- `make down` then `make` keeps everything.
- `make fclean` deletes the volumes AND the host folders.
Anything outside those two volumes is lost when a container is recreated.
