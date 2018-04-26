#!/bin/bash
source drv.core

EDGENAME=$1
EDGEADDRESS=$2
#context: {
#	cluster
#	host
#	datastore
#	vcenter
#	management
#	port1
#	port2
#	port3
#}

function getVC {
	read -r -d '' JQSPEC <<-CONFIG
		.results[]
			| select(.server=="${VCHOST}").id
	CONFIG
	local CMANAGER=$(./drv.cmanager.list.sh 2>/dev/null | jq -r "$JQSPEC")
	if [[ -n "${CMANAGER}" ]]; then
		printf "INFO: found [compute-manager] with name [${VCHOST}] id [${CMANAGER}]\n" 1>&2
		printf "${CMANAGER}"
	else
		printf "ERROR: Could not find [compute-manager] with name [${VCHOST}] - please join it to the NSX domain\n" 1>&2
	fi
}
CMANAGER=$(getVC)

read -r -d '' PAYLOAD <<CONFIG
{
	"resource_type": "EdgeNode",
	"display_name": "$EDGENAME",
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
						"$EDGEADDRESS"
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
			"hostname": "$EDGENAME",
			"placement_type": "VsphereDeploymentConfig",
			"storage_id": "datastore-11",
			"vc_id": "${CMANAGER}"
		}
	}
}
CONFIG

function request {
	URL="https://$HOST/api/v1/fabric/nodes"
	printf "NSX create edge [$EDGENAME:$EDGEADDRESS] - [$URL]... " 1>&2
	RESPONSE=$(curl -v -k -b cookies.txt -w "%{http_code}" -X POST \
	-H "`grep X-XSRF-TOKEN headers.txt`" \
	-H "Content-Type: application/json" \
	-d "$PAYLOAD" \
	"$URL" 2>/dev/null)
	isSuccess "$RESPONSE"
}

if [[ -n "${EDGENAME}" && "${EDGEADDRESS}" ]]; then
	request
else
	printf "ERROR: command usage: ${ORANGE}edge.create${LIGHTCYAN} <edgename> <edgeaddress>${NC}\n" 1>&2
fi
