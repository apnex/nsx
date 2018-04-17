#!/bin/bash

SESSION=$(./session.sh)
HOST=172.16.10.15
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
	else
		printf " - ERROR\n" 1>&2
		#printf "$HTTPBODY\n"
	fi
}

URL="https://$HOST/api/v1/fabric/nodes"
printf "Retrieving [$URL]... " 1>&2
RESPONSE=$(curl -k -b cookies.txt -w "%{http_code}" -X GET \
-H "`grep X-XSRF-TOKEN headers.txt`" \
-H "Content-Type: application/json" \
"$URL" 2>/dev/null)
isSuccess "$RESPONSE"
echo "$HTTPBODY"

URL="https://$HOST/api/v1/fabric/nodes/<node-id>/status"
#printf "Retrieving [$URL]... " 1>&2
#RESPONSE=$(curl -k -b cookies.txt -w "%{http_code}" -X GET \
#-H "`grep X-XSRF-TOKEN headers.txt`" \
#-H "Content-Type: application/json" \
#"$URL" 2>/dev/null)
#isSuccess "$RESPONSE"
#echo "$HTTPBODY"

