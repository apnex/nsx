#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi

TNNAME=$1
TNNODEID=$2
${WORKDIR}/drv.transport-nodes.create.sh "$1" "$2"
