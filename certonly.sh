#!/bin/ash -ex

cd $(dirname $0)
WD=$(pwd)
cd -

domains=$($WD/getDomains.sh /etc/bind/zones|tr '\n' ','|sed 's/,$//g')

certbot certonly -n --manual --text --agree-tos --preferred-challenges dns \
	--manual-auth-hook $WD/certonly-auth.sh \
	--manual-cleanup-hook $WD/certonly-cleanup.sh \
	--email $LETSENCRYPT_EMAIL \
	-d "$domains" \
	--expand \
	"$@"

domain=$(ls -ldtr /etc/letsencrypt/live/*|grep ^d|tail -1|awk '{ print $9 }'|sed 's#^/.*/##g')

[ ! -e /etc/letsencrypt/live/domain ] || rm  /etc/letsencrypt/live/domain
ln -s /etc/letsencrypt/live/${domain%%,*} /etc/letsencrypt/live/domain
