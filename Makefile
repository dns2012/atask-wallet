# Detect Docker Compose command
ifeq ($(shell docker compose version >/dev/null 2>&1 && echo true),true)
  DOCKER_COMPOSE := docker compose
else ifeq ($(shell docker-compose version >/dev/null 2>&1 && echo true),true)
  DOCKER_COMPOSE := docker-compose
else
  $(error "Neither 'docker compose' nor 'docker-compose' is available. Please install Docker Compose.")
endif

# Check Docker Compose version
check_docker_compose_version:
	@$(DOCKER_COMPOSE) version | grep -E "v[1-2]\.[0-9]+(\.[0-9]+)?" >/dev/null || \
	(echo "Error: Docker Compose v1.x or v2.x is required. Please install or update Docker Compose." && exit 1)

app_start: check_docker_compose_version
	$(DOCKER_COMPOSE) up -d --build

app_stop: check_docker_compose_version
	$(DOCKER_COMPOSE) down

app_restart:
	$(MAKE) app_stop
	$(MAKE) app_start

app_verify:
	docker ps

app_rollback:
	$(MAKE) db_rollback
	$(MAKE) atask_stock_rollback

db_setup:
	$(MAKE) db_migrate
	$(MAKE) db_seed

db_migrate: check_docker_compose_version
	$(DOCKER_COMPOSE) exec -it api rails db:migrate

db_seed: check_docker_compose_version
	$(DOCKER_COMPOSE) exec -it api rails db:seed

db_rollback: check_docker_compose_version
	$(DOCKER_COMPOSE) exec -it api rails db:migrate VERSION=0

atask_stock_setup: check_docker_compose_version
	$(DOCKER_COMPOSE) exec -it api cp /app/lib/atask_stock/lib/tasks/atask_stock.rake /app/lib/tasks/atask_stock.rake

atask_stock_publish: check_docker_compose_version
	$(DOCKER_COMPOSE) exec -it api rails atask_stock:publish
	$(MAKE) db_setup
	$(MAKE) app_restart
	$(MAKE) atask_stock_routes

atask_stock_rollback: check_docker_compose_version
	$(DOCKER_COMPOSE) exec -it api rails db:migrate:down VERSION=20241201020960
	$(DOCKER_COMPOSE) exec -it api rails atask_stock:rollback
	$(DOCKER_COMPOSE) exec -it api rm -rf /app/lib/tasks/atask_stock.rake 
	$(MAKE) app_restart
	$(MAKE) atask_stock_routes

atask_stock_routes: check_docker_compose_version
	$(DOCKER_COMPOSE) exec -it api rails routes -g stock
