FROM composer:2

RUN composer create-project flarum/flarum .
RUN composer require flarum/extension-manager:*

# fof
RUN composer require \
    fof/upload \
    fof/doorman \
    fof/user-directory \
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
    fof/user-bio

# etc
RUN composer require \
    michaelbelgium/flarum-discussion-views \
    davwheat/custom-sidenav-links \
    v17development/flarum-blog \
    kk14569/flarum-hubui-x \
    dalez/fluent-flarum

RUN composer install
