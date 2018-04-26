#!/bin/bash
source drv.core

TZNAME=$1
TZSWITCH=$2
TZTYPE=$3

URL="https://$HOST/api/v1/transport-zones"
printf "NSX create zone [$TZNAME:$TZSWITCH:$TZTYPE] - [$URL]... " 1>&2
read -r -d '' PAYLOAD <<CONFIG
{
	"display_name":"$TZNAME",
	"host_switch_name":"$TZSWITCH",
	"description":"$TZTYPE Transport-Zone",
	"transport_type":"$TZTYPE"
}
CONFIG
RESPONSE=$(curl -v -k -b nsx-cookies.txt -w "%{http_code}" -X POST \
-H "`grep X-XSRF-TOKEN nsx-headers.txt`" \
-H "Content-Type: application/json" \
-d "$PAYLOAD" \
"$URL" 2>/dev/null)
isSuccess "$RESPONSE"
