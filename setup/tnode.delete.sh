#!/bin/bash
source drv.core

TNID=$1

function request {
	local TNID=${1}
	URL="https://$HOST/api/v1/transport-nodes/${TNID}"
	printf "[INFO] nsx [delete] transport-node [${TNID}] - [$URL]... " 1>&2
	RESPONSE=$(curl -k -b nsx-cookies.txt -w "%{http_code}" -X DELETE \
	-H "`grep X-XSRF-TOKEN nsx-headers.txt`" \
	-H "Content-Type: application/json" \
	"$URL" 2>/dev/null)
	isSuccess "$RESPONSE"
}

if [[ -n "${TNID}" ]]; then
        request "${TNID}"
else
    	printf "[${ORANGE}ERROR${NC}]: Command usage: ${GREEN}tnode.delete${LIGHTCYAN} <tnid>${NC}\n" 1>&2
fi

