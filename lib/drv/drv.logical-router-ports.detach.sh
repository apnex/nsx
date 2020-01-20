#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="logical-router-ports"
INPUTS=()
INPUTS+=("<logical-router-ports.id>")

# body
RPID=${1}
read -r -d '' JQSPEC <<-CONFIG # override <tnid> in JSON
	.linked_logical_switch_port_id |= {}
CONFIG

# run
run() {
	BODY=$(${WORKDIR}/drv.logical-router-ports.list.sh 2>/dev/null | jq '.results | map(select(.id=="'${RPID}'")) | .[0]')
	NODE=$(echo "${BODY}" | jq -r "$JQSPEC")
	printf "${NODE}" | jq --tab . >${WORKDIR}/rp.spec
	${WORKDIR}/drv.logical-router-ports.patch.sh ${WORKDIR}/rp.spec
}

# driver
driver "${@}"
