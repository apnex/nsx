#!/bin/bash
source ./drv.core

ssh admin@${1} <<EOF
	join management-plane ${HOST} username ${USER} password ${PASSWORD} thumbprint ${THUMBPRINT}
	set control-cluster security-model shared-secret secret VMware1!
	initialize control-cluster
EOF
