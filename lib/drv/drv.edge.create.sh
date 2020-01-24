#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.vsp.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="transport-nodes"
valset "edge-vm.spec"

# body
SPEC=${1}
function getVC {
	read -r -d '' JQSPEC <<-CONFIG
		.results[] | select(.server=="${VSPHOST}").id
	CONFIG
	local CMANAGER=$(${WORKDIR}/drv.compute-manager.list.sh 2>/dev/null | jq -r "$JQSPEC")
	if [[ -n "${CMANAGER}" ]]; then
		printf "[$(cgreen "INFO")]: found [$(cgreen "compute-manager")] name [$(cgreen "${VSPHOST}")] uuid [$(cgreen "${CMANAGER}")]\n" 1>&2
		printf "${CMANAGER}"
	else
		printf "[$(corange "ERROR")]: fould not find [$(cgreen "compute-manager")] with name [$(cgreen "${VSPHOST}")] - please join it to the NSX domain\n" 1>&2
	fi
}
function makeBody {
	MYSPEC=$(cat "${SPEC}")
	read -r -d '' JQSPEC <<-CONFIG
		.node_deployment_info.deployment_config.vm_deployment_config.vc_id = "${1}"
	CONFIG
	local BODY=$(echo "${MYSPEC}" | jq -r "$JQSPEC")
	printf "${BODY}"
}

# run
run() {
	CMANAGER=$(getVC)
	BODY=$(makeBody "${CMANAGER}")
	URL=$(buildURL "${ITEM}")
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
		nsxPost "${URL}" "${BODY}"
	fi
}

# driver
driver "${@}"

