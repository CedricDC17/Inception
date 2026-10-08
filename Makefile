COMPOSE		= docker compose -f srcs/docker-compose.yml
DATA_DIR	= /home/cedurget/data
GREEN		= \033[0;32m
RED			= \e[0;31m
DEFAULT		= \033[0m

.PHONY: all dirs build up down clean fclean re list images acs

all: up

dirs:
	mkdir -p $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress

up: dirs
	sudo $(COMPOSE) up -d --build
	@echo "$(GREEN)\nUP at: $(RED)https://cedurget.42.fr\n$(GREEN)ADMIN panel at: $(RED)https://cedurget.42.fr/wp-admin$(DEFAULT)\n"

down:
	sudo $(COMPOSE) down

clean:
	sudo $(COMPOSE) down --rmi all

fclean: clean
	sudo $(COMPOSE) down -v
	sudo rm -rf $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress
	@echo "$(GREEN)=== ITS DONE ==="

list:
	sudo docker ps -a && sudo docker images

acs:
	sudo docker exec -it $(TARGET) bash

re: fclean up
