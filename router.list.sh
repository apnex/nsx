#!/bin/bash

RAW=$1
PAYLOAD=$(./drv.router.list.sh)
read -r -d '' JQSPEC <<CONFIG
	.results |
		["id", "display_name", "router_type"]
		,["-----", "-----", "-----"]
		,(.[] | [.id, .display_name, .router_type])
	| @csv
CONFIG
if [[ "$RAW" == "json" ]]; then
	echo "$PAYLOAD" | jq --tab .
else
	echo "$PAYLOAD" | jq -r "$JQSPEC" | sed 's/"//g' | column -s ',' -t
fi
