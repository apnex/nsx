#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.core
source ${WORKDIR}/drv.nsx.client

#1eda3bf1-03ec-4e50-8ea2-aa7c3b075084
CALL="${1}"
if [[ -n "${NSXHOST}" ]]; then
	ITEM="transport-nodes"
	URL=$(buildURL "${ITEM}")
	if [[ -n "${CALL}" ]]; then
		URL+="/${CALL}"
	fi
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "list")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		nsxGet "${URL}"
	fi
fi