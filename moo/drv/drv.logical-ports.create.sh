#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client

LSID=${1}
ADMINSTATE=${2}
LSNAME=${3}

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
		"display_name": "${LSNAME}"
	}
	CONFIG
	printf "${BODY}"
}

ITEM="logical-ports"
if [[ -n "${LSID}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		BODY=$(makeBody)
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
			nsxPost "${URL}" "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen ${TYPE}) $(ccyan "<logical-switch.id> [ <UP|DOWN> ]")\n" 1>&2
fi
