# User documentation

## Services

The project runs a WordPress website on three containers:

| Container | Role |
|---|---|
| nginx | Web server. Handles HTTPS on port 443. The only container reachable from outside |
| wordpress | WordPress and php-fpm. Runs the site's PHP code |
| mariadb | Database. Stores posts, pages, users and settings |

The website files and the database are stored on the host in `/home/cedurget/data`, so nothing is lost when containers are stopped or rebuilt.

## Start and stop

All commands are run from the root of the project.

| Command | Effect |
|---|---|
| `make` | Build the images if needed and start the three containers |
| `make down` | Stop and remove the containers. Data is kept |

Before the first start, the domain must point to the machine:

```bash
echo "127.0.0.1 cedurget.42.fr" | sudo tee -a /etc/hosts
```

## Access the website and admin panel

| | Address |
|---|---|
| Website | https://cedurget.42.fr |
| Admin panel | https://cedurget.42.fr/wp-admin |

The certificate is self-signed, so the browser shows a security warning on the first visit.

There are two accounts:

| User | Role | Can do |
|---|---|---|
| bigboss | Administrator | Everything: posts, themes, plugins, users, settings |
| cedric | Subscriber | Log in, read, edit own profile |

## Credentials

Passwords are stored in plain text files in the `secrets/` folder, which is excluded from Git.

Usernames, emails and the site title are set in `srcs/.env`.

To change a password after installation, use the WordPress admin panel (Users menu). Editing the files in `secrets/` only has an effect on a fresh install (`make re`).

## Check that services are running

List the containers:

```bash
docker ps
#or
make list
```

The three containers must appear with status `Up`.

the website:

```bash
# curl -k https://cedurget.42.fr
https://cedurget.42.fr
```
