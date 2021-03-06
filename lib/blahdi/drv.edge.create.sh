#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.core
source ${WORKDIR}/drv.vsp.client
source ${WORKDIR}/drv.nsx.client

function getVC {
	read -r -d '' JQSPEC <<-CONFIG
		.results[] | select(.server=="${VSPHOST}").id
	CONFIG
	local CMANAGER=$(./drv.compute-manager.list.sh 2>/dev/null | jq -r "$JQSPEC")
	if [[ -n "${CMANAGER}" ]]; then
		printf "[$(cgreen "INFO")]: found [$(cgreen "compute-manager")] name [$(cgreen "${VSPHOST}")] uuid [$(cgreen "${CMANAGER}")]\n" 1>&2
		printf "${CMANAGER}"
	else
		printf "[$(corange "ERROR")]: fould not find [$(cgreen "compute-manager")] with name [$(cgreen "${VSPHOST}")] - please join it to the NSX domain\n" 1>&2
	fi
}

function buildSpec {
	# work in progress - not currently functional
	local read -r -d '' CONTEXT <<-CONFIG
	{
		"name": "${EDGENAME}",
		"password": "VMware1!",
		"placement": {
			"vcenter": "${VSPHOST}",
			"cluster": "mgmt",
			"host": "sddc.lab",
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

ENAME=$1
EADDRESS=$2
function makeBody { ### need to update spec to enable SSH!
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
				"management_network_id": "dvportgroup-24",
				"management_port_subnets": [
					{
						"ip_addresses": [
							"$EADDRESS"
						],
						"prefix_length": 24
					}
				],
				"data_network_ids": [
					"dvportgroup-27",
					"dvportgroup-27",
					"dvportgroup-27"
			],
				"default_gateway_addresses": [
					"172.16.10.1"
				],
				"host_id": "host-133",
				"hostname": "$ENAME",
				"placement_type": "VsphereDeploymentConfig",
				"storage_id": "datastore-134",
				"vc_id": "${CMANAGER}"
			}
		}
	}
	CONFIG
	echo "${BODY}"
}

if [[ -n "${ENAME}" && "${EADDRESS}" ]]; then
	CMANAGER=$(getVC)
	if [[ -n "${CMANAGER}" && "${NSXHOST}" ]]; then
		BODY=$(makeBody)
		ITEM="fabric/nodes"
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
			nsxPost "${URL}" "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "edge.create") $(ccyan "<name> <ip-address>")\n" 1>&2
fi
