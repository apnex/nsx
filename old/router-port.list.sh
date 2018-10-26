#!/bin/bash

RAW=$1
PAYLOAD=$(./drv.router-port.list.sh)
read -r -d '' JQSPEC <<CONFIG
	.results |
		["id", "display_name", "resource_type", "logical_router_id", "mac_address", "ip_address", "prefix_length"]
		,["-----", "-----", "-----"]
		,(.[] | [.id, .display_name, .resource_type, .logical_router_id, .mac_address,
			.subnets[0].ip_addresses[0], .subnets[0].prefix_length
		])
	| @csv
CONFIG
if [[ "$RAW" == "json" ]]; then
	echo "$PAYLOAD" | jq --tab .
else
	echo "$PAYLOAD" | jq -r "$JQSPEC" | sed 's/"//g' | column -s ',' -t
fi
