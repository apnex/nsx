#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="edge-clusters"
INPUTS=()
INPUTS+=("<edge-clusters.id>")
INPUTS+=("<transport-nodes.id>")

# body
ECID=${1}
TNID=${2}
read -r -d '' JQSPEC <<-CONFIG # override <tnid> in JSON
	.members |= (
		del(.[] | select(.transport_node_id=="${TNID}"))
	)
CONFIG

# run
run() {
	BODY=$(${WORKDIR}/drv.edge-clusters.list.sh 2>/dev/null | jq --tab '.results | map(select(.id=="'${ECID}'")) | .[0]')
	NODE=$(echo "${BODY}" | jq -r "$JQSPEC")
	printf "${NODE}" | jq --tab . >${WORKDIR}/ec.spec
	${WORKDIR}/drv.edge-clusters.patch.sh ${WORKDIR}/ec.spec
}

# driver
driver "${@}"
