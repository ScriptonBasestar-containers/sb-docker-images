
init:
	@echo "clone or reset containers"
	git clone https://github.com/ory/kratos.git
	git clone https://github.com/ScriptonBasestar-containers/ory-kratos-selfservice-ui-node.git
	git clone https://github.com/ScriptonBasestar-containers/ory-kratos-selfservice-ui-react-nextjs.git
	#git clone https://github.com/go-kratos/examples.git
	#git clone https://github.com/go-kratos/kratos.git

build:
	@echo "Building containers..."
	(cd ./kratos; docker build -f .docker/Dockerfile-build -t oryd/kratos:latest .)
	(cd ./ory-kratos-selfservice-ui-node; make docker-dev-build)
	(cd ./ory-kratos-selfservice-ui-react-nextjs; make build)
	#(cd ./examples; make build)
	#(cd ./kratos; make build)

deploy:

run:
	docker compose up
