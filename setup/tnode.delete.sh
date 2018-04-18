#!/bin/bash

ID=$1
SESSION=$(./drv.session.sh)
HOST=$(cat nsx-credentials | jq -r .hostname)

function isSuccess { # add CASE for multiple 2XX and 3XX codes
	local STRING=${1}
	REGEX='^(.*)([0-9]{3})$'
	if [[ $STRING =~ $REGEX ]]; then
		HTTPBODY=${BASH_REMATCH[1]}
		HTTPCODE=${BASH_REMATCH[2]}
		printf "[$HTTPCODE]" 1>&2
	fi
	if [[ $HTTPCODE -eq "200" ]]; then
		printf " - SUCCESS\n" 1>&2
	else
		printf " - ERROR\n" 1>&2
		printf "$HTTPBODY"
	fi
}

if [ -n "$ID" ]; then
	SESSION=$(./session.sh)
	URL="https://$ENDPOINT/api/v1/transport-nodes/$ID"
	printf "NSX delete transport-node [$ID] - [$URL]... " 1>&2
	RESPONSE=$(curl -v -k -b cookies.txt -w "%{http_code}" -X DELETE \
	-H "`grep X-XSRF-TOKEN headers.txt`" \
	-H "Content-Type: application/json" \
	"$URL" 2>/dev/null)
	isSuccess "$RESPONSE"
else
	echo "Please provide a [transport-node] ID"
fi
