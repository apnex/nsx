#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.core
source ${WORKDIR}/drv.nsx.client

## inputs
ID=${1}

## status of node
function getStatus {
	local NODEID=${1}
	ITEM="transport-nodes"
	CALL="/${NODEID}/status"
	URL=$(buildURL "${ITEM}${CALL}")
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "status")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		nsxGet "${URL}"
	fi
}

## input validation
if [[ -n "${ID}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		getStatus "${ID}"
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "transport-nodes.state") $(ccyan "<transport-nodes.id>")\n" 1>&2
fi
