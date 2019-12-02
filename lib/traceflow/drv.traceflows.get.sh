#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.core
source ${WORKDIR}/drv.nsx.client

ID=${1}
ITEM="traceflows"
if [[ -n "${ID}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		CALL="/${ID}"
		URL=$(buildURL "${ITEM}${CALL}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "get")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
			nsxGet "${URL}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "${ITEM}.get") $(ccyan "<traceflows.id>")\n" 1>&2
fi
