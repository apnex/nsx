#!/bin/bash
EDGENAME=$1
EDGEADDRESS=$2

function getVC {
	read -r -d '' JQSPEC <<-CONFIG
		.results[]
			| select(.server=="${VCHOST}").id
	CONFIG
	local CMANAGER=$(./drv.cmanager.list.sh 2>/dev/null | jq -r "$JQSPEC")
	if [[ -n "${CMANAGER}" ]]; then
		printf "[${GREEN}INFO${NC}]: found [${GREEN}compute-manager${NC}] with name [${GREEN}${VCHOST}${NC}] id [${GREEN}${CMANAGER}${NC}]\n" 1>&2
		printf "${CMANAGER}"
	else
		printf "[${ORANGE}ERROR${NC}]: fould not find [${GREEN}compute-manager${NC}] with name [${GREEN}${VCHOST}${NC}] - please join it to the NSX domain\n" 1>&2
	fi
}

function buildSpec {
	# work in progress - not currently functional
	local read -r -d '' CONTEXT <<-CONFIG
	{
		"name": "${EDGENAME}",
		"password": "VMware1!",
		"placement": {
			"vcenter": "${VCHOST}",
			"cluster": "mgmt",
			"host": "esx01.lab",
			"datastore": "datastore1"
		},
		"mgmt": {
			"ip-address": "${EDGEADDRESS}"
			"netmask": 24,
			"gateway": "172.16.10.1"
		}
		"network": {
			"mgmt": "pg-mgmt",
			"data":	[
				"pg-trunk",
				"pg-trunk",
				"pg-trunk"
			]
		}
	}
	CONFIG
	INPUTPLACE=$(echo ${CONTEXT} | jq -r '.placement.vcenter')
	FINALPLACE=$(echo ${CONTEXT} | jq -r '.value[] | select(.name=="mgmt").cluster)')
}

function makeBody {
	read -r -d '' PAYLOAD <<-CONFIG
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
	echo "${PAYLOAD}"
}

function green {
	local STRING=${1}
	printf "${GREEN}${STRING}${NC}"
}

source drv.core
if [[ -n "${EDGENAME}" && "${EDGEADDRESS}" ]]; then
	CMANAGER=$(getVC)
	if [[ -n "${CMANAGER}" && "${HOST}" ]]; then
	 	BODY=$(makeBody)
		URL="https://$HOST/api/v1/fabric/nodes"
		printf "[$(green "INFO")]: nsx [$(green "create")] edge vm [$(green "$EDGENAME"):$(green "$EDGEADDRESS")] - [$(green "$URL")]... " 1>&2
		rPost "${URL}" "${BODY}"
	fi
else
	printf "[${ORANGE}ERROR${NC}]: command usage: ${GREEN}edge.create${LIGHTCYAN} <edgename> <edgeaddress>${NC}\n" 1>&2
fi
