#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client

NODEID=$1
if [[ -n "${NODEID}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		ITEM="transport-nodes"
		CALL="/${NODEID}?action=resync_host_config"
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
			nsxPost "${URL}${CALL}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "transport-nodes.resync") $(ccyan "<transport-nodes.id>")\n" 1>&2
fi
