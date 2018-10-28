#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.core
source ${WORKDIR}/drv.nsx.client

PLNAME=$1
PLCIDR=$2
REGEX='([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)[0-9]{1,3}\/[0-9]{2}'
if [[ $PLCIDR =~ $REGEX ]]; then # naive match - for 24 only
	OCTETS=${BASH_REMATCH[1]}
fi
POOLSTART="$OCTETS"10
POOLEND="$OCTETS"99
POOLGW="$OCTETS"1

function makeBody {
	read -r -d '' BODY <<-CONFIG
	{
		"display_name": "$PLNAME",
		"description": "$PLNAME",
		"subnets": [
			{
				"allocation_ranges": [
					{
						"start": "$POOLSTART",
						"end": "$POOLEND"
					}
				],
				"gateway_ip": "$POOLGW",
				"cidr": "$PLCIDR"
			}
		]
	}
	CONFIG
	printf "${BODY}"
}

if [[ -n "${PLNAME}" && "${PLCIDR}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		BODY=$(makeBody)
		ITEM="pools/ip-pools"
		URL=$(buildURL "${ITEM}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
			nsxPost "${URL}" "${BODY}"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "pool.create") $(ccyan "<name> <cidr>")\n" 1>&2
fi
