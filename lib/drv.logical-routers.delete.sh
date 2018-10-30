#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.core
source ${WORKDIR}/drv.nsx.client

ID=${1}
if [[ -n "${ID}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		ITEM="logical-routers"
		CALL="/${ID}"
		URL=$(buildURL "${ITEM}${CALL}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "delete")] ${ITEM} - [$(cgreen "$URL")]... " 1>&2
			nsxDelete "${URL}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "router.delete") $(ccyan "<uuid>")\n" 1>&2
fi
