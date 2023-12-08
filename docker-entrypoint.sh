#!/bin/ash -e

[ -n $DPSRV_DOMAIN ] || exit 0
[ -n $DPSRV_REGION ] || exit 0
[ -n $DPSRV_NODE ] || exit 0
host dns-main.$DPSRV_DOMAIN | grep -q ${DPSRV_REGION}-${DPSRV_NODE}.$DPSRV_DOMAIN || exit 0

cd $(dirname $0)
WD=$(pwd)
cd -

if [ -n "$*" ]; then
	exec certbot $*
	exit
fi

if [ -e /etc/letsencrypt/archive ]; then
	exec certbot renew --expand
	exit
fi

exec $WD/certonly.sh


