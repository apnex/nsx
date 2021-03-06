#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="logical-ports"
valset "logical-switch" "<logical-switches.id>"
valset "admin.state" "<[UP,DOWN]>"
valset "logical-port.name"

# body
LSID=${1}
ADMINSTATE=${2}
LPNAME=${3}
function makeBody {
	## check existing port?
	read -r -d '' BODY <<-CONFIG
	{
		"logical_switch_id": "${LSID}",
		"admin_state": "${ADMINSTATE}",
		"display_name": "${LPNAME}"
	}
	CONFIG
	printf "${BODY}"
}

# run
run() {
	BODY=$(makeBody)
	URL=$(buildURL "${ITEM}")
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
		nsxPost "${URL}" "${BODY}"
	fi
}

# driver
driver "${@}"
