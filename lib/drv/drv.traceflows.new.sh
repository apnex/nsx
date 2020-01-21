#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/mod.driver

# inputs
ITEM="traceflows"
INPUTS=()
INPUTS+=("<virtual-machines.id>")
INPUTS+=("<vifs.id>")
INPUTS+=("<virtual-machines.id>")
INPUTS+=("<vifs.id>")

# body
SRCVMID=${1}
SRCVIFID=${2}
DSTVMID=${3}
DSTVIFID=${4}
function makeBody {
	local SRCVIF=$(${WORKDIR}/drv.vifs.list.sh | jq -r '.results | map(select(.lport_attachment_id=="'${SRCVIFID}'")) | .[0]')
	local DSTVIF=$(${WORKDIR}/drv.vifs.list.sh | jq -r '.results | map(select(.lport_attachment_id=="'${DSTVIFID}'")) | .[0]')
	# src <virtual-machine>
	# src <vif>
	# dst <virtual-machine>
	# dst <vif>
	# update to <vifs.address>
	read -r -d '' BODY <<-CONFIG
	{
		"packet": {
			"resource_type": "FieldsPacketData",
			"routed": 0,
			"eth_header": {
				"src_mac": "$(echo ${SRCVIF} | jq -r '.mac_address')",
				"dst_mac": "$(echo ${DSTVIF} | jq -r '.mac_address')"
			},
			"ip_header": {
				"src_ip": "$(echo ${SRCVIF} | jq -r '.ip_address_info[0].ip_addresses[0]')",
				"dst_ip": "$(echo ${DSTVIF} | jq -r '.ip_address_info[0].ip_addresses[0]')"
			}
		},
		"lport_id": "<logical-port.id>"
	}
	CONFIG
	printf "${SRCVIF}" | jq -r '.' 1>&2
	printf "${DSTVIF}" | jq -r '.' 1>&2
	printf "${BODY}" | jq -r '.' 1>&2
}

# run
run() {
	BODY=$(makeBody)
	URL=$(buildURL "${ITEM}")
	if [[ -n "${URL}" ]]; then
		printf "[$(cgreen "INFO")]: nsx [$(cgreen "create")] ${ITEM} [$(cgreen "${URL}")]... " 1>&2
		#nsxPost "${URL}" "${BODY}"
	fi
}

# driver
driver "${@}"
