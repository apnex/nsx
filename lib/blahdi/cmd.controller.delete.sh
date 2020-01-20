#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi

ID=${1}
${WORKDIR}/drv.controller.delete.sh "$1"
