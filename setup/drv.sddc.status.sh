#!/bin/bash
source drv.core

NSXUSER=$(cat nsx-credentials | jq -r .username)
NSXPASS=$(cat nsx-credentials | jq -r .password)
NSXHOST=$(cat nsx-credentials | jq -r .hostname)
NSXDOMAIN=$(cat nsx-credentials | jq -r .domain)
NSXONLINE=$(cat nsx-credentials | jq -r .online)
VSPUSER=$(cat vsp-credentials | jq -r .username)
VSPPASS=$(cat vsp-credentials | jq -r .password)
VSPHOST=$(cat vsp-credentials | jq -r .hostname)
VSPDOMAIN=$(cat vsp-credentials | jq -r .domain)
VSPONLINE=$(cat vsp-credentials | jq -r .online)

FINAL=""
if [[ -n "${NSXHOST}" ]]; then
	NSXPING=$(ping -W 1 -c 1 "$NSXHOST" &>/dev/null && echo 1 || echo 0)
	if [[ "$NSXPING" == 1 ]]; then
		NSXPRINT=$(./thumbprint.sh "$NSXHOST")
	fi

	# build record
	read -r -d '' JQSPEC <<-CONFIG
		[
			(if "$NSXPING" == "1" then
				"REACHABLE"
			else
				"FAILED"
			end),
			(if ("$NSXPRINT" | length) != 0 then
				"ONLINE"
			else
				"FAILED"
			end)
		]
	CONFIG
	FINAL+=$(jq -n "$JQSPEC")
fi
FINAL+=","
if [[ -n "${VSPHOST}" ]]; then
	VSPPING=$(ping -W 1 -c 1 "$VSPHOST" &>/dev/null && echo 1 || echo 0)
	if [[ "$VSPPING" == 1 ]]; then
		VSPPRINT=$(./thumbprint.sh "$VSPHOST")
	fi

	# build record
	read -r -d '' JQSPEC <<-CONFIG
		[
			(if "$VSPPING" == "1" then
				"REACHABLE"
			else
				"FAILED"
			end),
			(if ("$VSPPRINT" | length) != 0 then
				"ONLINE"
			else
				"FAILED"
			end)
		]
	CONFIG
	FINAL+=$(jq -n "$JQSPEC")
fi
echo "[$FINAL]"
