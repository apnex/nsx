#!/bin/bash
source drv.core
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
	printf "[$(corange "ERROR")]: command usage: $(cgreen "tnode.resync") $(ccyan "<uuid>")\n" 1>&2
fi
