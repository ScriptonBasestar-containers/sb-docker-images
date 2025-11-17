.PHONY: help up down restart logs shell db-init db-upgrade clean

help:
	@echo "FlaskBB Docker Commands"
	@echo ""
	@echo "  make up          - 서비스 시작"
	@echo "  make down        - 서비스 중지"
	@echo "  make restart     - 서비스 재시작"
	@echo "  make logs        - 로그 확인"
	@echo "  make shell       - FlaskBB 컨테이너 쉘 접속"
	@echo "  make db-init     - 데이터베이스 초기화"
	@echo "  make db-upgrade  - 데이터베이스 마이그레이션"
	@echo "  make clean       - 모든 컨테이너 및 볼륨 삭제"

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

logs:
	docker compose logs -f

shell:
	docker compose exec flaskbb bash

db-init:
	docker compose exec flaskbb flaskbb install

db-upgrade:
	docker compose exec flaskbb flaskbb db upgrade

clean:
	docker compose down -v
	docker volume rm flaskbb_postgres-data flaskbb_redis-data flaskbb_flaskbb-uploads flaskbb_flaskbb-logs 2>/dev/null || true
