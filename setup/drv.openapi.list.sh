#!/bin/bash
source drv.core

if [[ -n "${HOST}" ]]; then
	ITEM="spec/openapi/nsx_api.json"
	URL=$(buildURL "${ITEM}")
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "list")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
		rGet "${URL}"
#https://172.16.10.15/api/v1/spec/openapi/nsx_api.json"
	fi
fi
