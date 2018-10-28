#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.core

if [ -z ${SDDCDIR} ]; then
	SDDCDIR=${WORKDIR}
fi
PARAMS=$(cat ${SDDCDIR}/sddc.parameters)
DOMAIN=$(echo "$PARAMS" | jq -r .domain)
DNS=$(echo "$PARAMS" | jq -r .dns)

OUTPUT=$(cat ${WORKDIR}/state/nsx.sddc.status.json)
printf "$OUTPUT"
