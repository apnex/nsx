#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="logical-ports"
valset "logical-port" "<logical-ports.id;attachment_type:.>"

# body
RPID=${1}
read -r -d '' JQSPEC <<-CONFIG
        del(.attachment)
CONFIG

# run
run() {
	BODY=$(${WORKDIR}/drv.logical-ports.list.sh 2>/dev/null | jq '.results | map(select(.id=="'${RPID}'")) | .[0]')
	NODE=$(echo "${BODY}" | jq -r "$JQSPEC")
	printf "${NODE}" | jq --tab . >${WORKDIR}/lp.spec
	${WORKDIR}/drv.logical-ports.patch.sh ${WORKDIR}/lp.spec
}

# driver
driver "${@}"
