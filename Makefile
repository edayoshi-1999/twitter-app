.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

# ========================================
# Docker操作
# ========================================

build: ## Build Docker containers
	docker compose build

up: ## Start Docker containers
	docker compose up -d

stop: ## Stop Docker containers
	docker compose stop

down: ## Stop and remove Docker containers
	docker compose down --remove-orphans

down-v: ## Stop and remove Docker containers and volumes
	docker compose down --remove-orphans --volumes

restart: ## Restart Docker containers
	@make down
	@make up

destroy: ## Remove all Docker containers, images, and volumes
	docker compose down --rmi all --volumes --remove-orphans

ps: ## Show running Docker containers
	docker compose ps

logs: ## Show all container logs
	docker compose logs -f

logs-laravel: ## Show Laravel container logs
	docker compose logs -f laravel

logs-react: ## Show React container logs
	docker compose logs -f react

logs-nginx: ## Show Nginx container logs
	docker compose logs -f nginx

logs-db: ## Show database container logs
	docker compose logs -f db

# ========================================
# コンテナアクセス
# ========================================

laravel: ## Access Laravel container shell
	docker compose exec laravel bash

laravel-root: ## Access Laravel container shell as root
	docker compose exec -u root laravel bash

react: ## Access React container shell
	docker compose exec react sh

react-bash: ## Access React container shell
	docker compose exec react sh

nginx: ## Access Nginx container shell
	docker compose exec nginx sh

db: ## Access database container shell
	docker compose exec db bash

psql: ## Access PostgreSQL CLI
	docker compose exec db psql -U laravel_user -d twitter_clone

# ========================================
# プロジェクトセットアップ
# ========================================

install: ## Install and setup the project
	@make build
	@make up
	@echo "Waiting for database to be ready..."
	@sleep 5
	@make backend-install
	@make frontend-install
	@echo "\n✅ Installation complete!"
	@echo "Backend API: http://localhost/api"
	@echo "Frontend: http://localhost"

backend-install: ## Install Laravel dependencies and setup
	docker compose exec laravel composer install
	docker compose exec laravel cp -n .env.example .env || true
	docker compose exec laravel php artisan key:generate
	docker compose exec laravel php artisan storage:link
	docker compose exec laravel chmod -R 777 storage bootstrap/cache
	@make migrate

frontend-install: ## Install React dependencies
	docker compose exec react npm install

# ========================================
# Laravel コマンド
# ========================================

migrate: ## Run Laravel migrations
	docker compose exec laravel php artisan migrate

fresh: ## Run fresh migrations with seed
	docker compose exec laravel php artisan migrate:fresh --seed

seed: ## Run Laravel seeders
	docker compose exec laravel php artisan db:seed

rollback: ## Rollback migration one step
	docker compose exec laravel php artisan migrate:status
	docker compose exec laravel php artisan migrate:rollback --step=1
	docker compose exec laravel php artisan migrate:status

rollback-5: ## Rollback migration 5 steps
	docker compose exec laravel php artisan migrate:status
	docker compose exec laravel php artisan migrate:rollback --step=5
	docker compose exec laravel php artisan migrate:status

rollback-test: ## Test migration rollbacks
	docker compose exec laravel php artisan migrate:fresh
	docker compose exec laravel php artisan migrate:refresh

tinker: ## Run Laravel Tinker
	docker compose exec laravel php artisan tinker

test: ## Run Laravel tests
	docker compose exec laravel php artisan test

test-pest: ## Run Laravel tests with Pest
	docker compose exec laravel vendor/bin/pest

test-coverage: ## Run Laravel tests with coverage
	docker compose exec laravel vendor/bin/pest --coverage

test-watch: ## Run Laravel tests in watch mode
	docker compose exec laravel vendor/bin/pest --watch

test-tweets: ## Run Laravel tweet feature tests
	docker compose exec laravel vendor/bin/pest tests/Feature/Tweet/

optimize: ## Run Laravel optimizations
	docker compose exec laravel php artisan optimize

optimize-clear: ## Clear Laravel optimizations
	docker compose exec laravel php artisan optimize:clear

cache: ## Generate Laravel caches
	docker compose exec laravel composer dump-autoload -o
	@make optimize
	docker compose exec laravel php artisan config:cache
	docker compose exec laravel php artisan route:cache
	docker compose exec laravel php artisan view:cache

cache-clear: ## Clear Laravel caches
	docker compose exec laravel composer clear-cache
	@make optimize-clear
	docker compose exec laravel php artisan config:clear
	docker compose exec laravel php artisan route:clear
	docker compose exec laravel php artisan view:clear

pint: ## Run Laravel Pint code formatter
	docker compose exec laravel vendor/bin/pint -v

pint-test: ## Test Laravel Pint code formatter
	docker compose exec laravel vendor/bin/pint -v --test

laravel-log: ## View Laravel logs
	docker compose exec laravel tail -f storage/logs/laravel.log

queue-work: ## Run Laravel queue worker
	docker compose exec laravel php artisan queue:work

queue-listen: ## Run Laravel queue listener
	docker compose exec laravel php artisan queue:listen

# ========================================
# React/Frontend コマンド
# ========================================

frontend-dev: ## Run React dev server
	docker compose exec react npm run dev

frontend-build: ## Build React for production
	docker compose exec react npm run build

frontend-preview: ## Preview React production build
	docker compose exec react npm run preview

frontend-test: ## Run React tests
	docker compose exec react npm test

frontend-test-ui: ## Run React tests with UI
	docker compose exec react npm run test:ui

frontend-test-coverage: ## Run React tests with coverage
	docker compose exec react npm run test:coverage

frontend-lint: ## Run Biome lint check
	docker compose exec react npm run lint

frontend-lint-fix: ## Run Biome lint and fix
	docker compose exec react npm run lint:fix

frontend-format: ## Run Biome format check
	docker compose exec react npm run format

frontend-format-fix: ## Run Biome format and fix
	docker compose exec react npm run format:fix

frontend-check: ## Run Biome check
	docker compose exec react npm run check

frontend-check-fix: ## Run Biome check and fix
	docker compose exec react npm run check:fix

# ========================================
# コード品質チェック（全体）
# ========================================

lint: ## Run all linters (backend + frontend)
	@echo "Running backend linter..."
	@make pint-test
	@echo "\nRunning frontend linter..."
	@make frontend-lint

lint-fix: ## Fix all linting issues (backend + frontend)
	@echo "Fixing backend code..."
	@make pint
	@echo "\nFixing frontend code..."
	@make frontend-check-fix

test-all: ## Run all tests (backend + frontend)
	@echo "Running backend tests..."
	@make test-pest
	@echo "\nRunning frontend tests..."
	@make frontend-test

# ========================================
# 開発便利コマンド
# ========================================

dev: ## Start development environment (up + logs)
	@make up
	@make logs

dev-backend: ## Open backend shell for development
	@echo "Opening Laravel container..."
	@make laravel

dev-frontend: ## Open frontend shell for development
	@echo "Opening React container..."
	@make react

status: ## Show project status
	@echo "=== Docker Containers ==="
	@make ps
	@echo "\n=== Database Status ==="
	@docker compose exec db pg_isready -U laravel_user -d twitter_clone || echo "Database not ready"

clean: ## Clean up cache and temporary files
	@echo "Cleaning Laravel cache..."
	@make cache-clear
	@echo "\nCleaning Docker..."
	docker compose exec laravel php artisan clear-compiled
	@echo "\nDone!"

remake: ## Destroy and reinstall the project
	@make destroy
	@make install

# ========================================
# データベース操作
# ========================================

db-reset: ## Reset database (fresh + seed)
	@make fresh

db-dump: ## Dump database to file
	docker compose exec db pg_dump -U laravel_user twitter_clone > backup_$$(date +%Y%m%d_%H%M%S).sql

db-restore: ## Restore database from file (usage: make db-restore FILE=backup.sql)
	docker compose exec -T db psql -U laravel_user -d twitter_clone < $(FILE)

# ========================================
# その他
# ========================================

ide-helper: ## Generate IDE helper files for Laravel
	docker compose exec laravel php artisan clear-compiled
	docker compose exec laravel php artisan ide-helper:generate
	docker compose exec laravel php artisan ide-helper:meta
	docker compose exec laravel php artisan ide-helper:models --nowrite

commit: ## Run commit script (if available in package.json)
	npm run commit
