#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi

CLID=${1}
${WORKDIR}/drv.edge-clusters.delete.sh "$1"
