#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="transport-nodes"
INPUTS=()
INPUTS+=("<transport-nodes.id>")
INPUTS+=("<logical-switches.id>")

# body
TNID=${1}
LSID=${2}
VMKID="vmk0"
GWPING="172.16.10.1"
function makeBody {
	local BODY=$(${WORKDIR}/drv.${ITEM}.list.sh 2>/dev/null | jq -r '.results | map(select(.node_id=="'${TNID}'")) | .[0]')
	printf "${BODY}"
}

# run
run() {
	BODY=$(makeBody)
	ITEM="transport-nodes/${TNID}"
	URL=$(buildURL "${ITEM}")
	URL+="?if_id=${VMKID}&esx_mgmt_if_migration_dest=${LSID}&ping_ip=${GWPING}"
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "update")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		nsxPut "${URL}" "${BODY}"
	fi
}

# driver
driver "${@}"
