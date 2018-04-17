#!/bin/bash

RAW=$1
PAYLOAD=$(./drv.node.list.sh)
read -r -d '' JQSPEC <<CONFIG
	.results |
		["id", "resource_type", "display_name", "ip_address"]
		,["-----", "-----", "-----", "-----"]
		,(.[] | [.id, .resource_type, .display_name, .ip_addresses[0]])
	| @csv
CONFIG
if [[ "$RAW" == "json" ]]; then
	echo "$PAYLOAD" | jq --tab .
else
	echo "$PAYLOAD" | jq -r "$JQSPEC" | sed 's/"//g' | column -s ',' -t
fi
