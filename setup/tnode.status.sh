#!/bin/bash

RAW=$1
PAYLOAD=$(./drv.tnode.status.sh)
read -r -d '' JQSPEC <<CONFIG
	.
		| ["id", "display-name", "node-id", "ip-address", "state", "device-name", "ip-address"]
		, ["-----", "-----", "-----", "-----", "-----", "-----", "-----"]
		, (.[] | [.[0], .[1], .[2], .[3], .[4], .[5], .[6]])
	| @csv
CONFIG
if [[ "$RAW" == "json" ]]; then
	echo "$PAYLOAD" | jq --tab .
else
	echo "$PAYLOAD" | jq -r "$JQSPEC" | sed 's/"//g' | column -s ',' -t
fi
