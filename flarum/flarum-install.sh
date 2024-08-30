	# https://friendsofflarum.org/
	docker run --rm -it -v ./app:/app composer composer require \
	flarum/extension-manager \
	fof/upload \
	fof/doorman \
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
	fof/user-bio \
	kk14569/flarum-hubui-x \
	dalez/fluent-flarum \
	davwheat/custom-sidenav-links \
	v17development/flarum-blog

	# - doctrine/dbal[v2.7.0, ..., v2.9.3] require php ^7.1 -> your php version (8.3.10) does not satisfy that requirement.
    # - doctrine/dbal[v2.10.0, ..., 2.10.4] require php ^7.2 -> your php version (8.3.10) does not satisfy that requirement.
    # - doctrine/dbal[2.11.0, ..., 2.11.3] require php ^7.3 -> your php version (8.3.10) does not satisfy that requirement.
    # - doctrine/dbal[2.12.0, ..., 2.13.9] require ext-pdo * -> it is missing from your system. Install or enable PHP's pdo extension.
    # - flamarkt/taxonomies 0.1.9 requires flarum/core ^1.2 -> satisfiable by flarum/core[v1.8.0, ..., v1.8.5].
    # - flarum/core[v1.8.0, ..., v1.8.5] require doctrine/dbal ^2.7 -> satisfiable by doctrine/dbal[v2.7.0, ..., 2.13.9].
    # - Root composer.json requires flamarkt/taxonomies ^0.1.9 -> satisfiable by flamarkt/taxonomies[0.1.9].
	# flamarkt/taxonomies \