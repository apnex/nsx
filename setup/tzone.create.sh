#!/bin/bash
source drv.core

TZNAME=$1
TZSWITCH=$2
TZTYPE=$3

read -r -d '' PAYLOAD <<-CONFIG
{
	"display_name":"$TZNAME",
	"host_switch_name":"$TZSWITCH",
	"description":"$TZTYPE Transport-Zone",
	"transport_type":"$TZTYPE"
}
CONFIG

function request {
	URL="https://$HOST/api/v1/transport-zones"
	printf "[INFO] nsx [create] transport-zone [$TZNAME:$TZSWITCH:$TZTYPE] - [$URL]... " 1>&2
	RESPONSE=$(curl -k -b nsx-cookies.txt -w "%{http_code}" -X POST \
	-H "`grep X-XSRF-TOKEN nsx-headers.txt`" \
	-H "Content-Type: application/json" \
	-d "$PAYLOAD" \
	"$URL" 2>/dev/null)
	isSuccess "$RESPONSE"
}

if [[ -n "${TZNAME}" && "${TZSWITCH}" && "${TZTYPE}" ]]; then
	request
else
	printf "[${ORANGE}ERROR${NC}]: Command usage: ${GREEN}tzone.create${LIGHTCYAN} <tzname> <tzswitch> <tztype>${NC}\n" 1>&2
fi

