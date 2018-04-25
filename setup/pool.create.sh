#!/bin/bash
source drv.core

POOLNAME=$1
POOLCIDR=$2
REGEX='([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)[0-9]{1,3}\/[0-9]{2}'
if [[ $POOLCIDR =~ $REGEX ]]; then # naive match - for 24 only
	OCTETS=${BASH_REMATCH[1]}
fi
POOLSTART="$OCTETS"10
POOLEND="$OCTETS"99
POOLGW="$OCTETS"1

URL="https://$HOST/api/v1/pools/ip-pools"
printf "NSX create pool [$POOLNAME] - [$URL]... " 1>&2
read -r -d '' PAYLOAD <<CONFIG
{
	"display_name": "$POOLNAME",
	"description": "$POOLNAME",
	"subnets": [
		{
			"allocation_ranges": [
				{
					"start": "$POOLSTART",
					"end": "$POOLEND"
				}
			],
			"gateway_ip": "$POOLGW",
			"cidr": "$POOLCIDR"
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
