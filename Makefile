
init0:
	# copy docker volume
	docker compose up -d

init1:
	#docker compose exec wordpress cp -r /var/www/html /var/www/html2
	docker compose cp ./common/config/kratos/. busybox:/kratos-config

teardown:
	docker compose down

enter:
	docker compose exec busybox sh
