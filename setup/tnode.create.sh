#!/bin/bash

NAME=$1
SWITCH=$2
TYPE=$3
SESSION=$(./drv.session.sh)
HOST=$(cat nsx-credentials | jq -r .hostname)

function isSuccess { # add CASE for multiple 2XX and 3XX codes
	local STRING=${1}
	REGEX='^(.*)([0-9]{3})$'
	if [[ $STRING =~ $REGEX ]]; then
		HTTPBODY=${BASH_REMATCH[1]}
		HTTPCODE=${BASH_REMATCH[2]}
		printf "[$HTTPCODE]" 1>&2
	fi
	if [[ $HTTPCODE -eq "200" ]]; then
		printf " - SUCCESS\n" 1>&2
	else
		printf " - ERROR\n" 1>&2
		printf "$HTTPBODY"
	fi
}

URL="https://$ENDPOINT/api/v1/transport-nodes"
printf "NSX create transport-node [$NAME:$SWITCH:$TYPE] - [$URL]... " 1>&2
read -r -d '' PAYLOAD <<CONFIG
{
	"resource_type": "TransportNode",
	"display_name": "node-01.lab",
	"description": "NSX configured Test Transport Node",
	"node_id": "1f3af28a-8231-459f-9f47-377029ae6068",
	"host_switch_spec": {
		"resource_type": "StandardHostSwitchSpec",
		"host_switches": [
			{
				"host_switch_profile_ids": [
					{
						"value": "2bf3522e-3332-4671-8e4a-d841259c1fab",
						"key": "UplinkHostSwitchProfile"
					}
				],
				"host_switch_name": "hs-fabric",
				"pnics": [
					{
						"device_name": "vmnic1",
						"uplink_name": "uplink1"
					}
				],
				"ip_assignment_spec": {
					"resource_type": "StaticIpPoolSpec",
					"ip_pool_id": "4da7fa96-a5ff-49a3-bf52-e1617156015f"
				}
			}
		]
	},
	"transport_zone_endpoints": [
		{
			"transport_zone_id": "b56988d6-7d50-4126-931f-b1c63ea0ca51"
		},
		{
			"transport_zone_id": "c769876e-4c83-4bd1-b6f3-debac7c9a110"
		}
	]
}
CONFIG
RESPONSE=$(curl -k -b cookies.txt -w "%{http_code}" -X POST \
-H "`grep X-XSRF-TOKEN headers.txt`" \
-H "Content-Type: application/json" \
-d "$PAYLOAD" \
"$URL" 2>/dev/null)
isSuccess "$RESPONSE"
