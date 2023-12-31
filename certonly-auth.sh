#!/bin/ash -ex
echo "$CERTBOT_DOMAIN: Validating $CERTBOT_VALIDATION"

domain=${CERTBOT_DOMAIN##\*.}
zoneFile=/etc/bind/zones/$domain

echo "_acme-challenge		TXT	$CERTBOT_VALIDATION" >> $zoneFile
serial=$(grep '; serial' $zoneFile|awk '{ print $1 }')
nextSerial=$( date +%s )
sed -i "s/[0-9]* ; serial/$nextSerial ; serial/" $zoneFile

NSs=$(nslookup -q=ns $domain $DPSRV_NS|grep "nameserver"|awk '{ print $4 }')

echo "$CERTBOT_DOMAIN@$NS: Waiting for $CERTBOT_VALIDATION"
for NS in $NSs; do
	while true; do
		records=$(nslookup -q=txt _acme-challenge.$domain $NS || true)
		if echo "$records" | grep -- $CERTBOT_VALIDATION; then
			break
		fi
		echo "$CERTBOT_DOMAIN@$NS: Still waiting for $CERTBOT_VALIDATION"
		sleep 5
	done
done
echo "$CERTBOT_DOMAIN@$NS: Found $CERTBOT_VALIDATION"


