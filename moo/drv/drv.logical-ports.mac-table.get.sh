#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client

PORTID=$1

ITEM="logical-ports"
if [[ -n "${NSXHOST}" && -n "${PORTID}" ]]; then
	URL=$(buildURL "${ITEM}")
	URL+="/${PORTID}/mac-table?source=realtime"

	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "list")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		nsxGet "${URL}"
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "${TYPE}") $(ccyan "<port.id>")\n" 1>&2
fi
