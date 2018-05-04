#!/bin/bash
source drv.core
NODEID=$1

if [[ -n "${NODEID}" ]]; then
	if [[ -n "${HOST}" ]]; then
		BODY=$(makeBody)
		ITEM="transport-nodes"
		CALL="/${NODEID}/status"
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
			rPost "${URL}" "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "tnode.create") $(ccyan "<name> <node-uuid>")\n" 1>&2
fi
