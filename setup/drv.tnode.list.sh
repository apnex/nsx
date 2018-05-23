#!/bin/bash
source drv.core
source drv.nsx.client

if [[ -n "${NSXHOST}" ]]; then
	ITEM="transport-nodes"
	URL=$(buildURL "${ITEM}")
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "list")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		nsxGet "${URL}"
	fi
fi
