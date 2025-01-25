

build:
	docker build . -t postgresql -f bitnami-vector.dockerfile

tag:
	docker tag postgresql ghcr.io/scriptonbasestar/bitnami-pg-vector:16.6-debian

push:
	docker push ghcr.io/scriptonbasestar/bitnami-pg-vector:16.6-debian

buildx:
	# docker buildx build . --platform linux/amd64,linux/arm64 -t ghcr.io/scriptonbasestar/bitnami-pg-vector:16.6-debian --push -f bitnami-vector.dockerfile
	docker buildx build . --platform linux/amd64,linux/arm64 -t docker.io/scriptonbasestar/bitnami-pg-vector:16.6-debian --push -f bitnami-vector.dockerfile
