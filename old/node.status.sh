#!/bin/bash

RAW=$1
PAYLOAD=$(./drv.node.status.sh)
read -r -d '' JQSPEC <<CONFIG
	.
		| ["id", "resource_type", "display_name", "ip_address", "status", "version"]
		, ["-----", "-----", "-----", "-----", "-----", "-----"]
		, (.[] | [.[0], .[1], .[2], .[3], .[4], .[5]])
	| @csv
CONFIG
if [[ "$RAW" == "json" ]]; then
	echo "$PAYLOAD" | jq --tab .
else
	echo "$PAYLOAD" | jq -r "$JQSPEC" | sed 's/"//g' | column -s ',' -t
fi
