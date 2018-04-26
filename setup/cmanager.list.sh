#!/bin/bash

RAW=$1
PAYLOAD=$(./drv.cmanager.list.sh)
read -r -d '' JQSPEC <<CONFIG
	.results |
		["id", "display_name", "ip_address", "origin_type", "version"]
		,["-----", "-----", "-----", "-----", "-----"]
		,(.[] | [.id, .display_name, .server, .origin_type,
			(if (.origin_properties | length) != 0 then
				(.origin_properties[] | select(.key=="version").value)
			else
				"not-registered"
			end)
		])
	| @csv
CONFIG
if [ -n "$PAYLOAD" ]; then
	if [[ "$RAW" == "json" ]]; then
		echo "$PAYLOAD" | jq --tab .
	else
		echo "$PAYLOAD" | jq -r "$JQSPEC" | sed 's/"//g' | column -s ',' -t
	fi
fi
