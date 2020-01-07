#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client

RPID=${1}

read -r -d '' JQSPEC <<-CONFIG # override <tnid> in JSON
	del(.attachment)
CONFIG

if [[ -n "${RPID}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		BODY=$(${WORKDIR}/drv.logical-ports.list.sh 2>/dev/null | jq '.results | map(select(.id=="'${RPID}'")) | .[0]')
		NODE=$(echo "${BODY}" | jq -r "$JQSPEC")
		printf "${NODE}" | jq --tab . >${WORKDIR}/lp.spec
		${WORKDIR}/drv.logical-ports.patch.sh ${WORKDIR}/lp.spec
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen ${TYPE}) $(ccyan "<logical-port.id>")\n" 1>&2
fi
