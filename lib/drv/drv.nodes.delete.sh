#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.vsp.client
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="fabric/nodes"
valset "node" "<nodes.id>"

# body
ID=${1}
function checkNodeType {
	local NODE=${1}
	PAYLOAD=$(${WORKDIR}/drv.transport-nodes.list.sh 2>/dev/null)
	read -r -d '' JQSPEC <<-CONFIG
		.results[] | select(.id=="${NODE}")
	CONFIG

	# add a check to see that node exists!
	EDGENODE=$(echo "$PAYLOAD" | jq -r "$JQSPEC")
	NODETYPE=$(echo "$EDGENODE" | jq -r ".node_deployment_info.resource_type")
	NODENAME=$(echo "$EDGENODE" | jq -r ".display_name")
	if [[ "$NODETYPE" == "EdgeNode" ]]; then
		read -r -d '' JQSPEC <<-CONFIG
			.node_deployment_info.deployment_config.vm_deployment_config.vc_id
		CONFIG
		NODEVC=$(echo "$EDGENODE" | jq -r "$JQSPEC")
		read -r -d '' JQSPEC <<-CONFIG
			.results[] | select(.id=="${NODEVC}")
		CONFIG
		CMANAGER=$(${WORKDIR}/drv.compute-managers.list.sh 2>/dev/null | jq -r "$JQSPEC | .id")
		if [[ -n "${CMANAGER}" ]]; then
			printf "[$(cgreen "INFO")]: found [$(cgreen "compute-manager")] name [$(cgreen "${VSPHOST}")] id [$(cgreen "${CMANAGER}")]\n" 1>&2
		else
			printf "[$(corange "WARNING")]: could not find [$(cgreen "compute-manager")] id [$(cgreen "${NODEVC}")]\n" 1>&2
			printf "[$(corange "WARNING")]: EdgeNode vm [$(cgreen "${NODENAME}")] is now orphaned and will need to be manually deleted\n" 1>&2
		fi
	else
		printf "[$(corange "WARNING")]: HostNode [$(cgreen "${NODENAME}")] is now orphaned and will need to be manually unprepared\n" 1>&2
	fi
}

# run
run() {
	checkNodeType "${ID}"
	URL=$(buildURL "${ITEM}")
	URL+="/${ID}"
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "delete")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		nsxDelete "${URL}"
	fi
}

# driver
driver "${@}"
