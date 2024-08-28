REPO=scriptonbasestar/sb-flarum
VERSION=3.0.11

setup:
	# git clone https://github.com/flarum/flarum --depth 1 app
	docker run --rm -it -v ./app:/app composer composer install
	# https://friendsofflarum.org/
	docker run --rm -it -v ./app:/app composer composer require \
	kk14569/flarum-hubui-x \
	dalez/fluent-flarum \
	davwheat/custom-sidenav-links \
	flarum/extension-manager:"*" \
	fof/upload \
	fof/doorman:"*" \
	fof/user-directory \
	michaelbelgium/flarum-discussion-views \
	fof/discussion-thumbnail \
	fof/impersonate \
	fof/follow-tags \
	fof/best-answer \
	fof/gamification \
	fof/recaptcha \
	fof/merge-discussions \
	fof/sitemap \
	fof/share-social \
	fof/pages \
	fof/polls \
	fof/formatting \
	fof/split \
	fof/gamification \
	fof/profile-image-crop \
	fof/default-user-preferences \
	fof/html-errors \
	flamarkt/taxonomies \
	fof/user-bio

	# fof/user-directory-stats \
	# fof/user-directory-sidebar \
	# fof/user-directory-sidebar-stats \
	# fof/user-directory-sidebar-best-answer \
	# fof/user-directory-sidebar-follow-tags \
	# fof/user-directory-sidebar-gamification \
	# fof/user-directory-sidebar-recaptcha \
	# fof/user-directory-sidebar-share-social \

teardown:
	rm -rf app
	docker compose down -v

build:
	docker compose build --no-cache
	# flrum migrate
	# flarum cache:clear
	# flarum vendor:publish
	# flarum vendor:install
	# flarum admin:generate

run:
	docker compose up

clean:
	docker rm -f $(docker ps -qa)
	docker rmi $(docker images -q)
