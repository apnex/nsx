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
INPUTS+=("vmnic.id")
INPUTS+=("uplink.name")

# body
TNID=${1}
VMNIC=${2}
UPLINK=${3}
function makeBody {
	local NODE=$(${WORKDIR}/drv.${ITEM}.list.sh 2>/dev/null | jq -r '.results | map(select(.node_id=="'${TNID}'")) | .[0]')
	read -r -d '' JQSPEC <<-CONFIG # override vmnic in JSON
		.host_switch_spec
		.host_switches[0]
		.pnics |= (
			del(.[] | select(.device_name=="${VMNIC}"))
			| . += [{
				"device_name": "${VMNIC}",
				"uplink_name": "${UPLINK}"
			}]
		)
	CONFIG
	local BODY=$(echo "${NODE}" | jq -r "$JQSPEC")
	printf "${BODY}"
}

# run
run() {
	BODY=$(makeBody)
	printf "${BODY}" | jq --tab . >${WORKDIR}/tn.spec
	${WORKDIR}/drv.${ITEM}.update.sh ${WORKDIR}/tn.spec
}

# driver
driver "${@}"
