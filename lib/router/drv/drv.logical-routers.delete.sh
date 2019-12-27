#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client

ID=${1}
ITEM="logical-routers"
if [[ -n "${ID}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		CALL="/${ID}"
		URL=$(buildURL "${ITEM}")
		URL+="/${CALL}"
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "delete")] ${ITEM} - [$(cgreen "$URL")]... " 1>&2
			nsxDelete "${URL}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen ${TYPE}) $(ccyan "<logical-router.id>")\n" 1>&2
fi
