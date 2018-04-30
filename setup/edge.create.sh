#!/bin/bash
ENAME=$1
EADDRESS=$2

function getVC {
	read -r -d '' JQSPEC <<-CONFIG
		.results[]
			| select(.server=="${VCHOST}").id
	CONFIG
	local CMANAGER=$(./drv.cmanager.list.sh 2>/dev/null | jq -r "$JQSPEC")
	if [[ -n "${CMANAGER}" ]]; then
		printf "[$(cgreen "INFO")]: found [$(cgreen "compute-manager")] name [$(cgreen "${VCHOST}")] uuid [$(cgreen "${CMANAGER}")]\n" 1>&2
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
	read -r -d '' BODY <<-CONFIG
	{
		"resource_type": "EdgeNode",
		"display_name": "$ENAME",
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
							"$EADDRESS"
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
				"hostname": "$ENAME",
				"placement_type": "VsphereDeploymentConfig",
				"storage_id": "datastore-11",
				"vc_id": "${CMANAGER}"
			}
		}
	}
	CONFIG
	echo "${BODY}"
}

source drv.core
if [[ -n "${ENAME}" && "${EADDRESS}" ]]; then
	CMANAGER=$(getVC)
	if [[ -n "${CMANAGER}" && "${HOST}" ]]; then
		BODY=$(makeBody)
		ITEM="fabric/nodes"
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
			rPost "${URL}" "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "edge.create") $(ccyan "<name> <cidr>")\n" 1>&2
fi
