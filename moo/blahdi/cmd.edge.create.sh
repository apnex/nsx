#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi

ENAME=${1}
EADDRES=${2}
${WORKDIR}/drv.edge.create.sh "$1" "$2"
