#!/bin/bash
source drv.core
source drv.nsx.client
source drv.vsp.client
ID=${1}

function checkManager {
	local NODE=${1}
	PAYLOAD=$(./drv.controller.list.sh 2>/dev/null)
	read -r -d '' JQSPEC <<-CONFIG
		.results[]
			| select(.vm_id=="${NODE}")
	CONFIG
	CTLNODE=$(echo "$PAYLOAD" | jq -r "$JQSPEC")
	NODEVC=$(echo "$CTLNODE" | jq -r ".deployment_config.vc_id")
	NODENAME=$(echo "$CTLNODE" | jq -r ".deployment_config.hostname")
	read -r -d '' JQSPEC <<-CONFIG
		.results[]
			| select(.id=="${NODEVC}")
	CONFIG
	CMANAGER=$(./drv.cmanager.list.sh 2>/dev/null | jq -r "$JQSPEC | .id")
	if [[ -n "${CMANAGER}" ]]; then
		printf "[$(cgreen "INFO")]: found [$(cgreen "compute-manager")] name [$(cgreen "${VSPHOST}")] id [$(cgreen "${CMANAGER}")]\n" 1>&2
	else
		printf "[$(corange "WARNING")]: could not find [$(cgreen "compute-manager")] id [$(cgreen "${NODEVC}")]\n" 1>&2
		printf "[$(corange "WARNING")]: controller vm [$(cgreen "${NODENAME}")] is now orphaned and will need to be manually deleted\n" 1>&2
	fi
}

if [[ -n "${ID}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		checkManager "${ID}"
		ITEM="cluster/nodes/deployments"
		CALL="/${ID}?action=delete"
		URL=$(buildURL "${ITEM}${CALL}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "delete")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
			nsxPost "${URL}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "controller.delete") $(ccyan "<uuid>")\n" 1>&2
fi
