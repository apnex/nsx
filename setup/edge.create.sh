#!/bin/bash

SESSION=$(./session.sh)
ENDPOINT="172.16.10.15"
HOSTNAME=$1
ADDRESS=$2

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

URL="https://$ENDPOINT/api/v1/fabric/nodes"
printf "NSX create edge [$HOSTNAME:$ADDRESS] - [$URL]... " 1>&2
read -r -d '' PAYLOAD <<CONFIG
{
	"resource_type": "EdgeNode",
	"display_name": "$HOSTNAME",
	"deployment_type": "VIRTUAL_MACHINE",
	"deployment_config": {
		"form_factor": "SMALL",
		"node_user_settings": {
			"cli_password": "VMware1!",
			"root_password": "VMware1!"
		},
		"vm_deployment_config" : {
			"compute_id": "domain-c7",
			"management_network_id": "dvportgroup-18",
			"management_port_subnets": [
				{
					"ip_addresses": [
						"$ADDRESS"
					],
					"prefix_length": 24
				}
			],
			"data_network_ids": [
				"dvportgroup-34",
				"dvportgroup-34",
				"dvportgroup-34"
			],
			"default_gateway_addresses": [
				"172.16.10.1"
			],
			"host_id": "host-10",
			"hostname": "$HOSTNAME",
			"placement_type": "VsphereDeploymentConfig",
			"storage_id": "datastore-11",
			"vc_id": "93721424-4764-48ed-a76c-91ded5ac4d11"
		}
	}
}
CONFIG
RESPONSE=$(curl -v -k -b cookies.txt -w "%{http_code}" -X POST \
-H "`grep X-XSRF-TOKEN headers.txt`" \
-H "Content-Type: application/json" \
-d "$PAYLOAD" \
"$URL" 2>/dev/null)
isSuccess "$RESPONSE"
