#!/bin/bash

RAW=$1
PAYLOAD=$(./drv.port.list.sh)
read -r -d '' JQSPEC <<CONFIG
	.results |
		["id", "display_name", "resource_type", "logical_switch_id", "admin_state", "attachment_type", "attachment_id"]
		,["-----", "-----", "-----", "-----", "-----", "-----", "-----"]
		,(.[] | [.id, .display_name, .resource_type, .logical_switch_id, .admin_state,
			.attachment.attachment_type, .attachment.id
		])
	| @csv
CONFIG
if [[ "$RAW" == "json" ]]; then
	echo "$PAYLOAD" | jq --tab .
else
	echo "$PAYLOAD" | jq -r "$JQSPEC" | sed 's/"//g' | column -s ',' -t
fi
