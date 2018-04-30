#!/bin/bash
TZNAME=$1
TZSWITCH=$2
TZTYPE=$3

function makeBody {
	read -r -d '' BODY <<-CONFIG
	{
		"display_name":"$TZNAME",
		"host_switch_name":"$TZSWITCH",
		"description":"$TZTYPE Transport-Zone",
		"transport_type":"$TZTYPE"
	}
	CONFIG
	printf "${BODY}"
}

source drv.core
if [[ -n "${TZNAME}" && "${TZSWITCH}" && "${TZTYPE}" ]]; then
	if [[ -n "${HOST}" ]]; then
		BODY=$(makeBody)
		ITEM="transport-zones"
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} - [$(cgreen "$URL")]... " 1>&2
			rPost "${URL}" "${BODY}"
		fi
	fi
else
	printf "[${ORANGE}ERROR${NC}]: Command usage: ${GREEN}tzone.create${LIGHTCYAN} <name> <mtu> <vlan>${NC}\n" 1>&2
fi
