#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="logical-ports"
INPUTS=()
INPUTS+=("<logical-switches.id>")
INPUTS+=("admin.state")
INPUTS+=("logical-port.name")

# body
LSID=${1}
ADMINSTATE=${2}
LPNAME=${3}

function makeBody {
	## check existing port?
	#local EDGECLUSTER=$(${WORKDIR}/drv.edge-clusters.list.sh 2>/dev/null)
	#local EDGEID=$(echo "${EDGECLUSTER}" | jq -r '.results | map(select(.display_name=="edge-cluster").id) | .[0]')
	local ENUM="UP"
	case "${ADMINSTATE}" in
		"DOWN")
			ENUM="DOWN"
		;;
	esac
	read -r -d '' BODY <<-CONFIG
	{
		"logical_switch_id": "${LSID}",
		"admin_state": "${ENUM}",
		"display_name": "${LPNAME}"
	}
	CONFIG
	printf "${BODY}"
}

# run
run() {
	BODY=$(makeBody)
	URL=$(buildURL "${ITEM}")
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
		nsxPost "${URL}" "${BODY}"
	fi
}

# driver
driver "${@}"
