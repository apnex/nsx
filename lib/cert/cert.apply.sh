#!/bin/bash
source drv.core
source drv.nsx.client

ID=${1}
if [[ -n "${ID}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		ITEM="node/services/http"
		ACTION="?action=apply_certificate&certificate_id=${ID}"
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "apply")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
			nsxPost "${URL}""$ACTION"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "cert.apply") $(ccyan "<cert-uuid>")\n" 1>&2
fi
