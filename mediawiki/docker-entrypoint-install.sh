#!/bin/bash

set -e

# variable must exists. no default value erorr
: "${DB_HOST:?DB_HOST is required}"
: "${DB_NAME:?DB_NAME is required}"
: "${DB_USER:?DB_USER is required}"
: "${DB_PASS:?DB_PASS is required}"
: "${SERVER_HOSTNAME:?SERVER_HOSTNAME is required}"
: "${WIKI_NAME:?WIKI_NAME is required}"
: "${ADMIN_USER:?ADMIN_USER is required}"
: "${ADMIN_PASS:?ADMIN_PASS is required}"

: "${DB_INSTALL_USER:=$DB_USER}"
: "${DB_INSTALL_PASS:=$DB_PASS}"

DEFAULT_SKIN_LIST="MinervaNeue,MonoBook,Timeless,Vector"
# : "${SKIN_LIST}"
: "${SKIN_LIST:=$DEFAULT_SKIN_LIST}"

# DEFAULT_EXT_LIST="AbuseFilter CategoryTree Cite CiteThisPage CodeEditor ConfirmEdit DiscussionTools Echo Gadgets ImageMap InputBox Interwiki Linter LoginNotify Math MultimediaViewer Nuke OATHAuth PageImages ParserFunctions PdfHandler Poem ReplaceText Scribunto SecureLinkFixer SpamBlacklist SyntaxHighlight_GeSHi TemplateData TextExtracts Thanks TitleBlacklist VisualEditor WikiEditor"
DEFAULT_EXT_LIST="AbuseFilter,CategoryTree,Cite,CiteThisPage,CodeEditor,ConfirmEdit,DiscussionTools,Echo,Gadgets,ImageMap,InputBox,Interwiki,Linter,LoginNotify,Math,MultimediaViewer,Nuke,OATHAuth,PageImages,ParserFunctions,PdfHandler,Poem,ReplaceText,Scribunto,SecureLinkFixer,SpamBlacklist,SyntaxHighlight_GeSHi,TemplateData,TextExtracts,Thanks,TitleBlacklist,VisualEditor,WikiEditor"
# : "${EXTENSION_LIST}"
: "${EXTENSION_LIST:=$DEFAULT_EXT_LIST}"

# : "${SERVER_PATH:=/w}"
: "${SERVER_PATH:=/}"
WIKI_LANG=${WIKI_LANG:-en}

APPENDS="$APPENDS --dbtype=mysql"
APPENDS="$APPENDS --dbssl=false"
APPENDS="$APPENDS --dbname=$DB_NAME"
APPENDS="$APPENDS --dbserver=$DB_HOST"
APPENDS="$APPENDS --dbuser=$DB_USER"
APPENDS="$APPENDS --dbpass=$DB_PASS"
# APPENDS="$APPENDS --installdbuser=$DB_INSTALL_USER"
# APPENDS="$APPENDS --installdbpass=\"$DB_INSTALL_PASS\""

APPENDS="$APPENDS --server=$SERVER_HOSTNAME"
APPENDS="$APPENDS --scriptpath=$SERVER_PATH"
APPENDS="$APPENDS --lang=$WIKI_LANG"
APPENDS="$APPENDS --pass=\"$ADMIN_PASS\""

# for skin in $SKIN_LIST; do
#     APPENDS="$APPENDS --skins=$skin"
# done
# APPENDS="$APPENDS --skins=\"$SKIN_LIST\""

# for ext in $EXTENSION_LIST; do
#     APPENDS="$APPENDS --with-extensions=$ext"
# don
APPENDS="$APPENDS --with-extensions=\"$EXTENSION_LIST\""

APPENDS="$APPENDS \"$WIKI_NAME\""
APPENDS="$APPENDS \"$ADMIN_USER\""

echo 'install mediawiki'
echo $APPENDS
#php maintenance/install.php $APPENDS
# --dbname=db01 --dbserver=mariadb --installdbuser=user01 --installdbpass=passw0rd --dbuser=user01 --dbpass=passw0rd --server=http://localhost:8080 --scriptpath=/ --lang=en --pass=qwer1234!@ --skins=MinervaNeue,MonoBook,Timeless,Vector --with-extensions=AbuseFilter,CategoryTree,Cite,CiteThisPage,CodeEditor,ConfirmEdit,DiscussionTools,Echo,Gadgets,ImageMap,InputBox,Interwiki,Linter,LoginNotify,Math,MultimediaViewer,Nuke,OATHAuth,PageImages,ParserFunctions,PdfHandler,Poem,ReplaceText,Scribunto,SecureLinkFixer,SpamBlacklist,SyntaxHighlight_GeSHi,TemplateData,TextExtracts,Thanks,TitleBlacklist,VisualEditor,WikiEditor MyWiki admin1
# php maintenance/install.php --dbname=db01 --dbserver=mariadb --installdbuser=user01 --installdbpass=passw0rd --dbuser=user01 --dbpass=passw0rd --server=http://localhost:8080 --scriptpath=/ --lang=en --pass=qwer1234!@ --skins=MinervaNeue,MonoBook,Timeless,Vector --with-extensions=AbuseFilter,CategoryTree,Cite,CiteThisPage,CodeEditor,ConfirmEdit,DiscussionTools,Echo,Gadgets,ImageMap,InputBox,Interwiki,Linter,LoginNotify,Math,MultimediaViewer,Nuke,OATHAuth,PageImages,ParserFunctions,PdfHandler,Poem,ReplaceText,Scribunto,SecureLinkFixer,SpamBlacklist,SyntaxHighlight_GeSHi,TemplateData,TextExtracts,Thanks,TitleBlacklist,VisualEditor,WikiEditor MyWiki admin1
# php maintenance/install.php --dbname=db01 --dbserver=mariadb --installdbuser=user01 --installdbpass=passw0rd --dbuser=user01 --dbpass=passw0rd --server=http://localhost:8080 --scriptpath=/ --lang=en --pass="qwer1234!@" MyWiki admin1
