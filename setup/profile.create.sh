#!/bin/bash
source drv.core

PFNAME=$1
PFMTU=$2
PFVLAN=$3

URL="https://$HOST/api/v1/host-switch-profiles"
printf "NSX create zone [$PFNAME:$PFMTU:$PFVLAN] - [$URL]... " 1>&2
read -r -d '' PAYLOAD <<CONFIG
{
	"resource_type": "UplinkHostSwitchProfile",
	"display_name": "$PFNAME",
	"mtu": $PFMTU,
	"teaming": {
		"standby_list": [],
		"active_list": [
			{
				"uplink_name": "uplink1",
				"uplink_type": "PNIC"
			}
		],
		"policy": "FAILOVER_ORDER"
	},
	"transport_vlan": $PFVLAN
}
CONFIG
RESPONSE=$(curl -k -b cookies.txt -w "%{http_code}" -X POST \
-H "`grep X-XSRF-TOKEN headers.txt`" \
-H "Content-Type: application/json" \
-d "$PAYLOAD" \
"$URL" 2>/dev/null)
isSuccess "$RESPONSE"
