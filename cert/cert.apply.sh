#!/bin/bash
CERTID=${1}

source drv.core
if [[ -n "${CERTID}" ]]; then
	if [[ -n "${HOST}" ]]; then
		BODY="action=apply_certificate&certificate_id=${CERTID}"
		ITEM="node/services/http"
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "apply")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
			rPost "${URL}" "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "cert.apply") $(ccyan "<cert-uuid>")\n" 1>&2
fi
