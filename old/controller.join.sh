#!/bin/bash
source drv.core
source drv.nsx.client

THUMBPRINT=$(./drv.sddc.status.sh | jq -r '.[] | select(.type=="nsx").thumbprint')
NSXADDR=$(./drv.sddc.status.sh | jq -r '.[] | select(.type=="nsx").dnsfwd')
ssh admin@${1} <<EOF
	join management-plane ${NSXADDR} username ${NSXUSER} password ${NSXPASS} thumbprint ${THUMBPRINT}
	set control-cluster security-model shared-secret secret VMware1!
	initialize control-cluster
EOF
