#!/bin/bash

NODEID=$1
SESSION=$(./drv.session.sh)
HOST=$(cat nsx-credentials | jq -r .hostname)

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

#URL="https://$HOST/api/v1/fabric/nodes/$1?unprepare_host=false"
#printf "Retrieving [$URL]... " 1>&2
#RESPONSE=$(curl -k -b cookies.txt -w "%{http_code}" -X DELETE \
#-H "`grep X-XSRF-TOKEN headers.txt`" \
#"$URL")
#isSuccess "$RESPONSE"

URL="https://$HOST/api/v1/fabric/nodes/$1"
printf "Retrieving [$URL]... " 1>&2
RESPONSE=$(curl -k -b cookies.txt -w "%{http_code}" -G -X DELETE \
-H "`grep X-XSRF-TOKEN headers.txt`" \
--data-urlencode "unprepare_host=false" \
"$URL" 2>/dev/null)
isSuccess "$RESPONSE"
