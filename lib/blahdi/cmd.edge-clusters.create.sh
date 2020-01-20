#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi

CLSTNAME=${1}
TNID=${2}
${WORKDIR}/drv.edge-clusters.create.sh "$1" "$2"
