#!/bin/ash -e

path=$1

zones=$(grep ^zone $path/../named.conf.zones|cut -d'"' -f2|sort -fu)

sorted=$(
for zone in $zones; do
	key=$(echo $zone|rev)
	echo $key $zone
done|sort -fu|awk '{ print $2 }'
)

filtered=$(
for zone in $sorted; do
	if [ -z "$last" ] || ! echo $zone | grep -q $last; then 
		echo $zone
	fi
	last=$zone
done|sort
)

for zone in $filtered; do
		echo $zone
		echo *.$zone
done
