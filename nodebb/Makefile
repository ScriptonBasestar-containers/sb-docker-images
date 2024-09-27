
setup:
	@echo "Installing dependencies..."
	git clone https://github.com/NodeBB/NodeBB.git

clear:
	@echo "Clear NodeBB..."
	rm -rf nodebb

build:
	@echo "Building NodeBB..."
	cd nodebb && npm install

run:
	@echo "Run NodeBB..."
	cd nodebb && docker compose up
