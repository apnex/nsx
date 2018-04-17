#!/bin/bash

PAYLOAD=$(./drv.cert.list.sh)
read -r -d '' JQSPEC <<CONFIG
	.results |
		["id", "display_name", "resource_type", "used_by"]
		,["--", "------------", "-------", "-----------"]
		,(.[] | [.id, .display_name, .resource_type, .used_by[0].service_types[0]])
	| @csv
CONFIG
if [[ "$RAW" == "json" ]]; then
	echo "$PAYLOAD" | jq --tab .
else
	echo "$PAYLOAD" | jq -r "$JQSPEC" | sed 's/"//g' | column -s ',' -t
fi
