

init:
	@echo "Initializing MailSlurper..."
	git clone https://github.com/mailslurper/mailslurper.git

build:
	@echo "Building MailSlurper..."
	docker build mailslurper -t scriptonbasestar/mailslurper --platform linux/arm64 --platform linux/amd64


	docker tag archmagece/mailslurper scriptonbasestar/mailslurper:go16-alpine16 