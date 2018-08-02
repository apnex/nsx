#!/bin/bash

RAW=$1
PAYLOAD=$(./drv.hostswitch-profile.list.sh)
read -r -d '' JQSPEC <<CONFIG
	.results |
		["id", "display_name", "resource_type", "transport_vlan", "mtu"]
		,["-----", "-----", "-----", "-----", "-----"]
		,(.[] | [.id, .display_name, .resource_type, .transport_vlan, .mtu])
	| @csv
CONFIG
if [[ "$RAW" == "json" ]]; then
	echo "$PAYLOAD" | jq --tab .
else
	echo "$PAYLOAD" | jq -r "$JQSPEC" | sed 's/"//g' | column -s ',' -t
fi
