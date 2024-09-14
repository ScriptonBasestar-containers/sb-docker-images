

init:
	git clone https://github.com/mailslurper/mailslurper
	git clone https://github.com/ory/mailslurper.git ory-mailslurper

build:
	docker build -t mailslurper mailslurper
	docker build -t ory-mailslurper ory-mailslurper -f ory-mailslurper/Dockerfile-smtps
