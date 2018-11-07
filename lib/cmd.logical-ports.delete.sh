#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi

PORTID=$1
${WORKDIR}/drv.logical-ports.delete.sh "$1"
