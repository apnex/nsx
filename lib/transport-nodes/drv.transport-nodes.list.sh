#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/mod.core
source ${WORKDIR}/drv.nsx.client

CALL="${1}"
if [[ -n "${NSXHOST}" ]]; then
	ITEM="transport-nodes"
	URL=$(buildURL "${ITEM}")
	if [[ -n "${URL}" ]]; then
		if [[ -n "${CALL}" ]]; then
			URL+="/${CALL}"
		fi
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "list")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		nsxGet "${URL}"
	fi
fi
