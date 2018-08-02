#!/bin/bash

RAW=$1
PAYLOAD=$(./drv.controller.list.sh)
read -r -d '' JQSPEC <<CONFIG
	.results |
		["id", "hostname", "role", "form_factor", "ip_address"]
		,["-----", "-----", "-----", "-----", "-----"]
		,(.[] | [.vm_id, .deployment_config.hostname, .roles[0], .form_factor, .deployment_config.management_port_subnets[0].ip_addresses[0]])
	| @csv
CONFIG
if [[ "$RAW" == "json" ]]; then
	echo "$PAYLOAD" | jq --tab .
else
	echo "$PAYLOAD" | jq -r "$JQSPEC" | sed 's/"//g' | column -s ',' -t
fi
