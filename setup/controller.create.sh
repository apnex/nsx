#!/bin/bash
source drv.core
source drv.nsx.client
CSECRET=$1

function makeBody {
	read -r -d '' BODY <<-CONFIG
	{
		"controller_role_config": {
			"type": "AddControllerNodeSpec",
			"host_msg_client_info": {
				"shared_secret": "${CSECRET}"
			},
			"mpa_msg_client_info": {
				"shared_secret": "${CSECRET}"
			}
		}
	}
	CONFIG
	printf "${BODY}"
}

if [[ -n "${CSECRET}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
	 	BODY=$(cat ctl.spec)
		ITEM="https://${NSXHOST}/api/v1/cluster/nodes/deployments"
		URL="${ITEM}"
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] controller-node [$(cgreen "$URL")]... " 1>&2
		nsxPost "${URL}" "${BODY}"
	fi
else
	printf "[$(corange "ERROR")] command usage: $(cgreen "controller.create") $(ccyan "<password>")\n" 1>&2
fi
