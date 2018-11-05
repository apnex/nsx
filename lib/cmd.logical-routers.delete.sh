#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi

ROUTERID=$1
${WORKDIR}/drv.logical-routers.delete.sh "$1"
