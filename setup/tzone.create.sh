#!/bin/bash
source drv.core

NAME=$1
SWITCH=$2
TYPE=$3

URL="https://$HOST/api/v1/transport-zones"
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
