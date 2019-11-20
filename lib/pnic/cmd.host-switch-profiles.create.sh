#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi

HSPNAME=${1}
HSPMTU=${2}
HSPVLAN=${3}
${WORKDIR}/drv.host-switch-profiles.create.sh "$1" "$2" "$3"
