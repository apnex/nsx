#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi

SECRET=${1}
${WORKDIR}/drv.controller.create.sh $SECRET
