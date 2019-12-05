#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client

CALL="${1}"
ITEM="transport-nodes"
if [[ -n "${NSXHOST}" ]]; then
	URL=$(buildURL "${ITEM}")
	if [[ -n "${URL}" ]]; then
		if [[ -n "${CALL}" ]]; then # rethink?
			URL+="/${CALL}"
		fi
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "list")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		nsxGet "${URL}"
	fi
fi
