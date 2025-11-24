.PHONY: help up down logs restart clean ps web api test

help:
	@echo "MailSlurper Standalone - SMTP Mail Testing Server"
	@echo ""
	@echo "Available commands:"
	@echo "  make up           - Start MailSlurper"
	@echo "  make down         - Stop MailSlurper"
	@echo "  make logs         - View logs"
	@echo "  make restart      - Restart MailSlurper"
	@echo "  make ps           - Show running containers"
	@echo "  make clean        - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "MailSlurper commands:"
	@echo "  make web          - Open web UI in browser"
	@echo "  make api          - Test API connection"
	@echo "  make test         - Send test email"
	@echo ""
	@echo "Access URLs:"
	@echo "  Web UI: http://localhost:8085"
	@echo "  API: http://localhost:8080"
	@echo "  SMTP: localhost:2500"

up:
	docker compose up -d
	@echo ""
	@echo "✅ MailSlurper is starting..."
	@echo ""
	@echo "Access URLs:"
	@echo "  Web UI: http://localhost:8085"
	@echo "  API: http://localhost:8080"
	@echo "  SMTP: localhost:2500"
	@echo ""
	@echo "Configure your app:"
	@echo "  SMTP_HOST=localhost"
	@echo "  SMTP_PORT=2500"

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all captured emails!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

web:
	@echo "Opening Web UI..."
	@command -v xdg-open > /dev/null && xdg-open http://localhost:8085 || \
	command -v open > /dev/null && open http://localhost:8085 || \
	echo "Please open http://localhost:8085 in your browser"

api:
	@echo "Testing API connection..."
	@curl -s http://localhost:8080/mail | head -20 || echo "API not available"

test:
	@echo "Sending test email..."
	@echo -e "Subject: Test Email\nFrom: test@example.com\nTo: recipient@example.com\n\nThis is a test email." | \
	nc localhost 2500 || echo "Failed to send test email"
	@echo "Check Web UI at http://localhost:8085"
