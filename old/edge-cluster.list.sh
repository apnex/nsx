#!/bin/bash

RAW=$1
PAYLOAD=$(./drv.edge-cluster.list.sh)
read -r -d '' JQSPEC <<-CONFIG
	.results |
		["id", "display_name", "deployment_type", "members"]
		,["-----", "-----", "-----", "-----"]
		,(.[] | [.id, .display_name, .deployment_type,
			(.members[] | .transport_node_id)
		])
	| @csv
CONFIG
if [[ "$RAW" == "json" ]]; then
	echo "$PAYLOAD" | jq --tab .
else
	echo "$PAYLOAD" | jq -r "$JQSPEC" | sed 's/"//g' | column -s ',' -t
fi
