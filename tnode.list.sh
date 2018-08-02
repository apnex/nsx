#!/bin/bash

RAW=$1
PAYLOAD=$(./drv.tnode.list.sh)
read -r -d '' JQSPEC <<CONFIG
	.results |
		["id", "display_name", "node_id", "host_switch"]
		,["-----", "-----", "-----", "-----"]
		,(.[] | [.id, .display_name, .node_id, .host_switch_spec.host_switches[0].host_switch_name])
	| @csv
CONFIG
if [[ "$RAW" == "json" ]]; then
	echo "$PAYLOAD" | jq --tab .
else
	echo "$PAYLOAD" | jq -r "$JQSPEC" | sed 's/"//g' | column -s ',' -t
fi
