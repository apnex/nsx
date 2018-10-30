#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi

NODEID=$1
${WORKDIR}/drv.transport-nodes.resync.sh "$1"
