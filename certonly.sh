#!/bin/ash -ex

[ -n $DPSRV_REGION ] || exit
[ -n $DPSRV_DOMAIN ] || exit
host dns-main.$DPSRV_REGION | grep -q $DPSRV_REGION.$DPSRV_DOMAIN || exit

exit

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

domain=${domains%%,*}

[ ! -e /etc/letsencrypt/live/domain ] || rm  /etc/letsencrypt/live/domain
ln -s /etc/letsencrypt/live/${domain%%,*} /etc/letsencrypt/live/domain
