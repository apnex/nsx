#!/bin/bash
source drv.core

TZID=$1

function request {
	local TZID=${1}
	URL="https://$HOST/api/v1/transport-zones/${TZID}"
	printf "[INFO] nsx [delete] transport-zone [${TZID}] - [$URL]... " 1>&2
	RESPONSE=$(curl -k -b nsx-cookies.txt -w "%{http_code}" -X DELETE \
	-H "`grep X-XSRF-TOKEN nsx-headers.txt`" \
	-H "Content-Type: application/json" \
	"$URL" 2>/dev/null)
	isSuccess "$RESPONSE"
}

if [[ -n "${TZID}" ]]; then
        request "${TZID}"
else
    	printf "[${ORANGE}ERROR${NC}]: Command usage: ${GREEN}tzone.delete${LIGHTCYAN} <tzid>${NC}\n" 1>&2
fi

