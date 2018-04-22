#!/bin/bash
source ./drv.source

NAME=$1
SWITCH=$2
TYPE=$3
SESSION=$(session)

URL="https://$HOST/api/v1/host-switch-profiles"
printf "NSX create zone [$NAME:$SWITCH:$TYPE] - [$URL]... " 1>&2
read -r -d '' PAYLOAD <<CONFIG
{
	"resource_type": "UplinkHostSwitchProfile",
	"display_name": "pf-uplink",
	"mtu": 1700,
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
	"transport_vlan": 0
}
CONFIG
RESPONSE=$(curl -k -b cookies.txt -w "%{http_code}" -X POST \
-H "`grep X-XSRF-TOKEN headers.txt`" \
-H "Content-Type: application/json" \
-d "$PAYLOAD" \
"$URL" 2>/dev/null)
isSuccess "$RESPONSE"
