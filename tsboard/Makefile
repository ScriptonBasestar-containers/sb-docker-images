
prepare:
	@echo "Preparing tsboard"
	git clone https://github.com/sirini/tsboard.git repos/tsboard
	git clone https://github.com/sirini/goapi.git repos/goapi

setup:
	@echo "Setting up tsboard"

build:
	@echo "Building tsboard"
	docker build . \
	-t tsboard \
	-f dockerfiles/frontend-tsboard.dockerfile
	docker build . \
	-t goapi \
	-f dockerfiles/backend-goapi.dockerfile
