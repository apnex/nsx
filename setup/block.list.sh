#!/bin/bash

RAW=$1

PAYLOAD=$(./drv.block.list.sh)
read -r -d '' JQSPEC <<CONFIG
	.results |
		["id", "display_name", "cidr"]
		,["-----", "-----", "-----"]
		,(.[] | [.id, .display_name, .cidr])
	| @csv
CONFIG
if [[ "$RAW" == "json" ]]; then
	echo "$PAYLOAD" | jq --tab .
else
	echo "$PAYLOAD" | jq -r "$JQSPEC" | sed 's/"//g' | column -s ',' -t
fi
