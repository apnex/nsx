#!/bin/bash

NAME=$1
CIDR=$2
SESSION=$(./drv.session.sh)
HOST=$(cat nsx-credentials | jq -r .hostname)

REGEX='([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)[0-9]{1,3}\/[0-9]{2}'
if [[ $CIDR =~ $REGEX ]]; then # naive match - for 24 only
	OCTETS=${BASH_REMATCH[1]}
fi
START="$OCTETS"10
END="$OCTETS"99
GATEWAY="$OCTETS"1

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

URL="https://$ENDPOINT/api/v1/pools/ip-pools"
printf "NSX create pool [$NAME] - [$URL]... " 1>&2
read -r -d '' PAYLOAD <<CONFIG
{
	"display_name": "$NAME",
	"description": "$NAME",
	"subnets": [
		{
			"allocation_ranges": [
				{
					"start": "$START",
					"end": "$END"
				}
			],
			"gateway_ip": "$GATEWAY",
			"cidr": "$CIDR"
		}
	]
}
CONFIG
RESPONSE=$(curl -v -k -b cookies.txt -w "%{http_code}" -X POST \
-H "`grep X-XSRF-TOKEN headers.txt`" \
-H "Content-Type: application/json" \
-d "$PAYLOAD" \
"$URL" 2>/dev/null)
isSuccess "$RESPONSE"
