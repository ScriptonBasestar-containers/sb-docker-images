.PHONY: help prepare clean

help:
	@echo "Available commands:"
	@echo "  prepare      - Clone devpi repository and plugins"
	@echo "  setup        - Setup directories and permissions"
	@echo "  build        - Build Docker image (with web interface)"
	@echo "  build-full   - Build image with all plugins enabled"
	@echo "  build-minimal- Build minimal image (no web interface)"
	@echo "  build-custom - Build custom image with specific plugins"
	@echo "               Usage: make build-custom web=true constrained=true"
	@echo "  push         - Push image to registry"
	@echo "  clean        - Clean up cloned repositories and Docker resources"
	@echo "  server-up    - Start devpi server"
	@echo "  server-down  - Stop devpi server"
	@echo "  server-logs  - View server logs"
	@echo "  server-enter - Enter running container"

prepare:
	@echo "Preparing devpi environment..."
	rm -rf devpi
	git clone https://github.com/devpi/devpi.git --depth 1
	git clone https://github.com/devpi/devpi-constrained.git --depth 1
	git clone https://github.com/devpi/devpi-findlinks.git --depth 1
	git clone https://github.com/devpi/devpi-jenkins.git --depth 1
	git clone https://github.com/devpi/devpi-lockdown.git --depth 1
	@echo "devpi repository cloned successfully"

clean:
	@echo "Cleaning up..."
	rm -rf devpi devpi-constrained devpi-findlinks devpi-jenkins devpi-lockdown
	rm -rf data logs

.PHONY: source
source:
	@echo "Source"
	@#$(MAKE) -f Makefile.source.mk $(MAKECMDGOALS)
	@make -f Makefile.source.mk --no-print-directory $(REM_ARGS)

.PHONY: pypi
pypi-%:
	@echo "Pypi"
	@#$(MAKE) -f Makefile.pypi.mk $(MAKECMDGOALS)
	@make -f Makefile.pypi.mk --no-print-directory $*
