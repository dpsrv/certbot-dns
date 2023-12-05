#!/bin/ash -e

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


