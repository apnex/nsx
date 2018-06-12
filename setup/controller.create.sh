#!/bin/bash
source drv.core
source drv.nsx.client
source drv.vsp.client
CSECRET=$1

function getVC {
	read -r -d '' JQSPEC <<-CONFIG
		.results[]
			| select(.server=="${VSPHOST}").id
	CONFIG
	local CMANAGER=$(./drv.cmanager.list.sh 2>/dev/null | jq -r "$JQSPEC")
	if [[ -n "${CMANAGER}" ]]; then
		printf "[$(cgreen "INFO")]: found [$(cgreen "compute-manager")] name [$(cgreen "${VSPHOST}")]\n" 1>&2 #uuid [$(cgreen "${CMANAGER}")]\n" 1>&2
		printf "${CMANAGER}"
	else
		printf "[$(corange "ERROR")]: fould not find [$(cgreen "compute-manager")] with name [$(cgreen "${VSPHOST}")] - please join it to the NSX domain\n" 1>&2
	fi
}

function makeBody {
	read -r -d '' BODY <<-CONFIG
	{
		"deployment_requests": [
			{
				"roles": [
					"CONTROLLER"
				],
				"form_factor": "SMALL",
				"user_settings": {
					"cli_password": "VMware1!",
					"root_password": "VMware1!"
				},
				"deployment_config": {
					"placement_type": "VsphereClusterNodeVMDeploymentConfig",
					"vc_id": "${CMANAGER}",
					"allow_ssh_root_login": true,
					"enable_ssh": true,
					"management_network_id": "dvportgroup-62",
					"hostname": "controller-1",
					"compute_id": "domain-c7",
					"storage_id": "datastore-11",
					"default_gateway_addresses": [
						"172.16.10.1"
					],
					"management_port_subnets": [
						{
							"ip_addresses": [
								"172.16.10.16"
							],
							"prefix_length": "24"
						}
					]
				}
			}
		],
		"clustering_config": {
			"clustering_type": "ControlClusteringConfig",
			"shared_secret": "VMware1!",
			"join_to_existing_cluster": false
		}
	}
	CONFIG
	printf "${BODY}"
}

if [[ -n "${CSECRET}" ]]; then
	CMANAGER=$(getVC)
	if [[ -n "${CMANAGER}" && "${NSXHOST}" ]]; then
	 	BODY=$(makeBody)
		ITEM="https://${NSXHOST}/api/v1/cluster/nodes/deployments"
		URL="${ITEM}"
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] controller-node [$(cgreen "${ITEM}")]... " 1>&2
		nsxPost "${URL}" "${BODY}"
	fi
else
	printf "[$(corange "ERROR")] command usage: $(cgreen "controller.create") $(ccyan "<password>")\n" 1>&2
fi
