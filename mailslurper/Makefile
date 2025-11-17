.PHONY: help prepare build tag up down logs restart ps clean shell

help:
	@echo "MailSlurper - SMTP Mail Server for Development"
	@echo ""
	@echo "Available commands:"
	@echo "  make prepare  - Clone MailSlurper repository"
	@echo "  make build    - Build Docker image"
	@echo "  make tag      - Tag Docker image"
	@echo "  make up       - Start MailSlurper"
	@echo "  make down     - Stop MailSlurper"
	@echo "  make restart  - Restart MailSlurper"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access MailSlurper container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"

prepare:
	@if [ ! -d "mailslurper" ]; then \
		git clone https://github.com/mailslurper/mailslurper.git; \
		echo "✅ MailSlurper repository cloned"; \
	else \
		echo "✅ MailSlurper repository already exists"; \
	fi

build:
	docker build mailslurper -t scriptonbasestar/mailslurper --platform linux/arm64 --platform linux/amd64

tag:
	docker tag archmagece/mailslurper scriptonbasestar/mailslurper:go16-alpine16

up:
	docker compose up -d
	@echo ""
	@echo "✅ MailSlurper is starting..."

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all MailSlurper data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec mailslurper sh 