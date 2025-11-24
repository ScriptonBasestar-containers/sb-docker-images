
setup:
	@echo "Installing dependencies..."
	git clone https://github.com/NodeBB/NodeBB.git nodebb
	chown -R 1001:1001 nodebb/.docker
	sudo rm -r nodebb/.docker/database/postgresql/data/.gitkeep

reset:
	@echo "Reset NodeBB..."
	cd nodebb && docker compose down -v
	rm -rf nodebb/.docker/
	git -C nodebb clean -fd nodebb
	git -C nodebb reset --hard HEAD

teardown:
	@echo "Removing dependencies..."
	rm -rf nodebb

clear:
	@echo "Clear NodeBB..."
	rm -rf nodebb

build:
	@echo "Building NodeBB..."
	cd nodebb && npm install

run:
	@echo "Run NodeBB..."
	cd nodebb && docker compose up
