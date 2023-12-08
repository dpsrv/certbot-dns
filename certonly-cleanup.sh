#!/bin/ash -ex
echo "$CERTBOT_DOMAIN: Cleanup $CERTBOT_VALIDATION"

domain=${CERTBOT_DOMAIN##\*.}
zoneFile=/etc/bind/zones/$domain

serial=$(grep '; serial' $zoneFile|awk '{ print $1 }')
nextSerial=$( date +%s )
sed -i -e "/^_acme-challenge[\t[:space:]]*TXT[\t[:space:]]*$CERTBOT_VALIDATION/d" -e "s/[0-9]* ; serial/$nextSerial ; serial/" $zoneFile

