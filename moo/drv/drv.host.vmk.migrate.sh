#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client

TNID=$1
LSID=$2
VMKID="vmk0"
GWPING="172.16.10.1"

# get latest revision
function makeBody {
	local BODY=$(${WORKDIR}/drv.transport-nodes.list.sh "${TNID}")
	printf "${BODY}"
}

if [[ -n "${TNID}" && "${LSID}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		BODY=$(makeBody "${TNID}")
		ITEM="transport-nodes/${TNID}"
		URL=$(buildURL "${ITEM}")
		URL+="?if_id=${VMKID}&esx_mgmt_if_migration_dest=${LSID}&ping_ip=${GWPING}"
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "update")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
			nsxPut "${URL}" "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "vmk.migrate") $(ccyan "<transport-node.id> <logical-switch.id>")\n" 1>&2
fi
