#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi

POOLNAME=${1}
POOLCIDR=${2}
${WORKDIR}/drv.pool.create.sh "$1" "$2"
