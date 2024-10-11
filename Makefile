# docker remote 빌드테스트를 위한도구
# 리모트 볼륨에 복사. docker swarm에도 사용가능. ... 오바인것같아서 안쓸예정
init0:
	# copy docker volume
	docker compose up -d

init1:
	#docker compose exec wordpress cp -r /var/www/html /var/www/html2
	docker compose cp ./composebox/config/kratos/. busybox:/kratos-config

teardown:
	docker compose down

enter:
	docker compose exec busybox sh
