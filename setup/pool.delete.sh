#!/bin/bash

HOST=172.16.10.15
ID=$1

function isSuccess {
	local STRING=${1}
	REGEX='^(.*)([0-9]{3})$'
	if [[ $STRING =~ $REGEX ]]; then
		HTTPBODY=${BASH_REMATCH[1]}
		HTTPCODE=${BASH_REMATCH[2]}
		printf "[$HTTPCODE]" 1>&2
	fi
	if [[ $HTTPCODE -eq "200" ]]; then
		printf " - SUCCESS\n" 1>&2
		printf "$HTTPBODY\n"
	else
		printf " - ERROR\n" 1>&2
		printf "$HTTPBODY\n"
	fi
}

if [ -n "$ID" ]; then
	SESSION=$(./session.sh)
	URL="https://$HOST/api/v1/pools/ip-pools/$ID"
	printf "Retrieving [$URL]... " 1>&2
	RESPONSE=$(curl -k -b cookies.txt -w "%{http_code}" -G -X DELETE \
	-H "`grep X-XSRF-TOKEN headers.txt`" \
	--data-urlencode "force=true" \
	"$URL" 2>/dev/null)
	isSuccess "$RESPONSE"
else
	echo "Please specify a pool ID"
fi

