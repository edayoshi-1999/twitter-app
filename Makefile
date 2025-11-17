# ========================================
# Help
# ========================================

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

# ========================================
# Docker操作
# ========================================

.PHONY: build up stop down down-v restart destroy ps logs logs-laravel logs-react logs-nginx logs-db

build: ## Build Docker containers
	docker compose build --parallel

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

.PHONY: laravel laravel-root react nginx db psql

laravel: ## Access Laravel container shell
	docker compose exec laravel bash

laravel-root: ## Access Laravel container shell as root
	docker compose exec -u root laravel bash

react: ## Access React container shell
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

.PHONY: install init backend-install frontend-install

install: ## Install and setup the project
	@make build
	@make up
	@echo "⏳ Waiting for database to be ready (max 60s)..."
	@count=0; \
	until docker compose exec -T db pg_isready -U laravel_user -d twitter_clone > /dev/null 2>&1; do \
		sleep 1; \
		count=$$((count + 1)); \
		if [ $$count -ge 60 ]; then \
			echo "❌ Database failed to start within 60 seconds"; \
			echo "   Check logs: make logs-db"; \
			exit 1; \
		fi; \
	done
	@echo "✅ Database is ready!"
	@make backend-install
	@make frontend-install
	@echo ""
	@echo "✅ Installation complete!"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "🌐 Frontend:     http://localhost"
	@echo "🔌 Backend API:  http://localhost/api"
	@echo "🗄️  Database:     localhost:5432"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "📝 Next steps:"
	@echo "  make dev          # Start development (with logs)"
	@echo "  make laravel      # Enter Laravel container"
	@echo "  make react        # Enter React container"
	@echo ""

init: install ## Alias for install

backend-install: ## Install Laravel dependencies and setup
	docker compose exec laravel composer install --prefer-dist --no-interaction
	@docker compose exec laravel test -f .env > /dev/null 2>&1 || \
		(docker compose exec laravel cp .env.example .env && echo "✅ Created .env file")
	@docker compose exec laravel grep -q "APP_KEY=base64:" .env 2>/dev/null || \
		(docker compose exec laravel php artisan key:generate && echo "✅ Generated APP_KEY")
	@docker compose exec laravel test -L public/storage > /dev/null 2>&1 || \
		(docker compose exec laravel php artisan storage:link && echo "✅ Created storage link")
	@echo "🔒 Setting permissions (775 for security)..."
	@docker compose exec laravel chmod -R 775 storage bootstrap/cache
	@docker compose exec laravel chown -R www-data:www-data storage bootstrap/cache 2>/dev/null || true
	@make migrate

frontend-install: ## Install React dependencies
	docker compose exec react npm ci

# ========================================
# Laravel コマンド
# ========================================

.PHONY: migrate fresh seed rollback rollback-5 rollback-test tinker test test-pest test-coverage test-watch test-tweets
.PHONY: optimize optimize-clear cache cache-clear pint pint-test laravel-log queue-work queue-listen

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

rollback-5: ## Rollback migrations 5 steps back
	docker compose exec laravel php artisan migrate:status
	docker compose exec laravel php artisan migrate:rollback --step=5
	docker compose exec laravel php artisan migrate:status

rollback-test: ## Test migration rollbacks (fresh + refresh)
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
	@docker compose exec laravel test -f storage/logs/laravel.log || \
		docker compose exec laravel touch storage/logs/laravel.log
	docker compose exec laravel tail -f storage/logs/laravel.log

queue-work: ## Run Laravel queue worker
	docker compose exec laravel php artisan queue:work

queue-listen: ## Run Laravel queue listener
	docker compose exec laravel php artisan queue:listen

# ========================================
# React/Frontend コマンド
# ========================================

.PHONY: frontend-dev frontend-build frontend-preview frontend-test frontend-test-ui frontend-test-coverage
.PHONY: frontend-lint frontend-lint-fix frontend-format frontend-format-fix frontend-check frontend-check-fix

frontend-dev: ## Run React dev server
	docker compose exec react npm run dev

frontend-build: ## Build React for production
	docker compose exec react npm run build

frontend-preview: ## Preview React production build
	docker compose exec react npm run preview

frontend-test: ## Run React tests (non-interactive)
	docker compose exec react npm test -- --run

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

.PHONY: lint lint-fix test-all ci

lint: ## Run all linters (backend + frontend)
	@echo "🔍 Running backend linter..."
	@if ! make pint-test; then \
		echo "❌ Backend linting failed"; \
		exit 1; \
	fi
	@echo ""
	@echo "🔍 Running frontend linter..."
	@if ! make frontend-lint; then \
		echo "❌ Frontend linting failed"; \
		exit 1; \
	fi
	@echo ""
	@echo "✅ All linting passed!"

lint-fix: ## Fix all linting issues (backend + frontend)
	@echo "🔧 Fixing backend code..."
	@if ! make pint; then \
		echo "⚠️  Backend formatting encountered issues"; \
	fi
	@echo ""
	@echo "🔧 Fixing frontend code..."
	@if ! make frontend-check-fix; then \
		echo "⚠️  Frontend formatting encountered issues"; \
	fi
	@echo ""
	@echo "✅ Code formatting complete!"

test-all: ## Run all tests (backend + frontend)
	@echo "🧪 Running backend tests..."
	@if ! make test-pest; then \
		echo "❌ Backend tests failed"; \
		exit 1; \
	fi
	@echo ""
	@echo "🧪 Running frontend tests..."
	@if ! make frontend-test; then \
		echo "❌ Frontend tests failed"; \
		exit 1; \
	fi
	@echo ""
	@echo "✅ All tests passed!"

ci: ## Run CI pipeline (lint + test)
	@echo "🚀 Running CI pipeline..."
	@make lint
	@make test-all
	@echo ""
	@echo "✅ CI pipeline passed!"

# ========================================
# 開発便利コマンド
# ========================================

.PHONY: dev dev-backend dev-frontend status clean remake

dev: ## Start development environment (up + logs)
	@make up
	@make logs

dev-backend: ## Open backend shell for development
	@echo "🚀 Opening Laravel container..."
	@make laravel

dev-frontend: ## Open frontend shell for development
	@echo "🚀 Opening React container..."
	@make react

status: ## Show project status
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "📊 Project Status"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "🐳 Docker Containers:"
	@docker compose ps
	@echo ""
	@echo "🗄️  Database Status:"
	@docker compose exec -T db pg_isready -U laravel_user -d twitter_clone > /dev/null 2>&1 \
		&& echo "✅ Database is ready" \
		|| echo "❌ Database is not ready"
	@echo ""

clean: ## Clean up cache and temporary files
	@echo "🧹 Cleaning Laravel cache..."
	@make cache-clear 2>/dev/null || true
	@echo ""
	@echo "🧹 Cleaning compiled files..."
	@docker compose exec laravel php artisan clear-compiled 2>/dev/null || true
	@echo ""
	@echo "✅ Cleanup complete!"

remake: ## Destroy and reinstall the project
	@echo "⚠️  WARNING: This will destroy all containers and volumes!"
	@echo "⚠️  All data will be lost!"
	@echo ""
	@read -p "Type 'yes' to continue: " confirm; \
	if [ "$$confirm" != "yes" ]; then \
		echo "❌ Aborted"; \
		exit 1; \
	fi
	@make destroy
	@make install

# ========================================
# データベース操作
# ========================================

.PHONY: db-reset db-dump db-restore db-backup

db-reset: ## Reset database (fresh + seed)
	@make fresh

db-dump: ## Dump database to file
	@mkdir -p backups
	@timestamp=$$(date +%Y%m%d_%H%M%S); \
	docker compose exec -T db pg_dump -U laravel_user twitter_clone > backups/backup_$$timestamp.sql && \
	echo "✅ Database dumped to backups/backup_$$timestamp.sql"

db-backup: db-dump ## Alias for db-dump

db-restore: ## Restore database from file (usage: make db-restore FILE=backup.sql)
ifndef FILE
	@echo "❌ Error: FILE parameter is required"
	@echo ""
	@echo "Usage:"
	@echo "  make db-restore FILE=backups/backup_YYYYMMDD_HHMMSS.sql"
	@echo ""
	@echo "Available backups:"
	@ls -1 backups/*.sql 2>/dev/null | tail -5 || echo "  No backups found"
	@exit 1
endif
	@if [ ! -f "$(FILE)" ]; then \
		echo "❌ Error: File '$(FILE)' not found"; \
		exit 1; \
	fi
	@echo "⚠️  This will overwrite the current database!"
	@read -p "Type 'yes' to continue: " confirm; \
	if [ "$$confirm" != "yes" ]; then \
		echo "❌ Aborted"; \
		exit 1; \
	fi
	docker compose exec -T db psql -U laravel_user -d twitter_clone < $(FILE)
	@echo "✅ Database restored from $(FILE)"

# ========================================
# その他
# ========================================

.PHONY: ide-helper

ide-helper: ## Generate IDE helper files for Laravel
	@if ! docker compose exec laravel composer show | grep -q "barryvdh/laravel-ide-helper"; then \
		echo "⚠️  laravel-ide-helper is not installed"; \
		echo "   Install it with: docker compose exec laravel composer require --dev barryvdh/laravel-ide-helper"; \
		exit 1; \
	fi
	docker compose exec laravel php artisan clear-compiled
	docker compose exec laravel php artisan ide-helper:generate
	docker compose exec laravel php artisan ide-helper:meta
	docker compose exec laravel php artisan ide-helper:models --nowrite
	@echo "✅ IDE helper files generated"
