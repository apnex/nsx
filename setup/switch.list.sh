#!/bin/bash

RAW=$1
PAYLOAD=$(./drv.switch.list.sh)
read -r -d '' JQSPEC <<CONFIG
	.results |
		["id", "display_name", "vni", "vlan", "admin_state"]
		,["-----", "-----", "-----", "-----", "-----"]
		,(.[] | [.id, .display_name, .vni, .vlan, .admin_state])
	| @csv
CONFIG
if [[ "$RAW" == "json" ]]; then
	echo "$PAYLOAD" | jq --tab .
else
	echo "$PAYLOAD" | jq -r "$JQSPEC" | sed 's/"//g' | column -s ',' -t
fi
