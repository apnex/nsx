#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client

RPID=${1}

read -r -d '' JQSPEC <<-CONFIG # override <tnid> in JSON
	.linked_logical_switch_port_id |= {}
CONFIG

if [[ -n "${RPID}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		BODY=$(${WORKDIR}/drv.logical-router-ports.list.sh 2>/dev/null | jq '.results | map(select(.id=="'${RPID}'")) | .[0]')
		NODE=$(echo "${BODY}" | jq -r "$JQSPEC")
		printf "${NODE}" | jq --tab . >${WORKDIR}/rp.spec
		${WORKDIR}/drv.logical-router-ports.patch.sh ${WORKDIR}/rp.spec
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen ${TYPE}) $(ccyan "<logical-router-port.id>")\n" 1>&2
fi
