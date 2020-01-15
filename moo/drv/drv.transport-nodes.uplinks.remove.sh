#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client

TNID=${1}
VMNIC=${2}

read -r -d '' JQSPEC <<-CONFIG # override vmnic in JSON
	.host_switch_spec
	.host_switches[0]
	.pnics = (
		.host_switch_spec.host_switches[0].pnics
		| del(.[] | select(.device_name=="${VMNIC}"))
	)
CONFIG

if [[ -n "${TNID}" && -n "${VMNIC}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		BODY=$(${WORKDIR}/drv.transport-nodes.list.sh 2>/dev/null | jq --tab '.results | map(select(.node_id=="'${TNID}'")) | .[0]')
		NODE=$(echo "${BODY}" | jq -r "$JQSPEC")
		printf "${NODE}" | jq --tab . >${WORKDIR}/tn.spec
		${WORKDIR}/drv.transport-nodes.update.sh ${WORKDIR}/tn.spec
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "transport-nodes.uplink.remove") $(ccyan "<transport-node.id> <vmnic.id>")\n" 1>&2
fi
