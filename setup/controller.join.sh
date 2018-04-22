#!/bin/bash
source ./drv.core

NODE=$1
THUMBPRINT=$(./thumbprint.sh "$HOST")
ssh admin@${HOST} <<EOF
	join management-plane ${HOST} username admin password VMware1!VMware1! thumbprint ${THUMBPRINT}
	set control-cluster security-model shared-secret secret VMware1!
	initialize control-cluster
EOF
