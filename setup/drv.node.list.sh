#!/bin/bash
source drv.core

if [[ -n "${HOST}" ]]; then
	ITEM="fabric/nodes"
	URL=$(buildURL "${ITEM}")
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "list")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		rGet "${URL}"
	fi
fi
