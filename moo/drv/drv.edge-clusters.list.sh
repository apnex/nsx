#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client

if [[ -n "${NSXHOST}" ]]; then
	ITEM="edge-clusters"
	URL=$(buildURL "${ITEM}")
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "list")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		nsxGet "${URL}"
	fi
fi
