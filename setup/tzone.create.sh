#!/bin/bash

SESSION=$(./session.sh)
ENDPOINT="172.16.10.15"
NAME=$1
SWITCH=$2
TYPE=$3

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

URL="https://$ENDPOINT/api/v1/transport-zones"
printf "NSX create zone [$NAME:$SWITCH:$TYPE] - [$URL]... " 1>&2
read -r -d '' PAYLOAD <<CONFIG
{
	"display_name":"$NAME",
	"host_switch_name":"$SWITCH",
	"description":"$TYPE Transport-Zone",
	"transport_type":"$TYPE"
}
CONFIG
RESPONSE=$(curl -v -k -b cookies.txt -w "%{http_code}" -X POST \
-H "`grep X-XSRF-TOKEN headers.txt`" \
-H "Content-Type: application/json" \
-d "$PAYLOAD" \
"$URL" 2>/dev/null)
isSuccess "$RESPONSE"
