#!/bin/bash
source drv.core
source drv.nsx.client

BODY="state/cert-import.json"
if [[ -n "${BODY}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		BODY=$(cat "${BODY}")
		ITEM="trust-management/certificates"
		ACTION="?action=import"
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
			nsxPost "${URL}""${ACTION}" "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "cert.import") $(ccyan "<file>")\n" 1>&2
fi
