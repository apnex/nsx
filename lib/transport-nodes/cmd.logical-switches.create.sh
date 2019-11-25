#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi

LSNAME=$1
LSTZONE=$2
LSVLAN=$3
${WORKDIR}/drv.logical-switches.create.sh "$1" "$2" "$3"
