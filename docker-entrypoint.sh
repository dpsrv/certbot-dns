#!/bin/ash -e

[ -n $DPSRV_DOMAIN ] || exit
[ -n $DPSRV_REGION ] || exit
[ -n $DPSRV_NODE ] || exit
host dns-main.$DPSRV_DOMAIN | grep -q ${DPSRV_REGION}-${DPSRV_NODE}.$DPSRV_DOMAIN || exit

cd $(dirname $0)
WD=$(pwd)
cd -

if [ -n "$*" ]; then
	exec certbot $*
	exit
fi

if [ -e /etc/letsencrypt/archive ]; then
	exec certbot renew 
	exit
fi

exec $WD/certonly.sh


