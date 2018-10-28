#!/bin/bash
source drv.core

DOMAIN=$(cat sddc.parameters | jq -r .domain)
DNS=$(cat sddc.parameters | jq -r .dns)

# 1 get the parameters
# 2 resolve the hostname in dns
# 3 ping the hostname || or if IP - ping the IP address
# 4 get the SSL thumbprint
# 5 attempt auth?
function buildItem {
	local SPEC=${1}
	local HOST=$(echo "${SPEC}" | jq -r '.hostname')
	if [[ -n "${HOST}" ]]; then
		local TYPE=$(echo "${SPEC}" | jq -r '.type')
		local CHECKFWD=""
		local CHECKREV=""
		if [[ "$HOST" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
			CHECKFWD="$HOST"
		else
			HOST+=".$DOMAIN"
			if [[ "$(host -t A -W 1 "$HOST" "$DNS")" =~ ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})$ ]]; then
				CHECKFWD="${BASH_REMATCH[1]}"
			fi
		fi
		if [[ -n "$CHECKFWD" ]]; then
			if [[ "$(host -t SRV -W 1 "$CHECKFWD" "$DNS")" =~ ([0-9a-z.-]+)$ ]]; then
				CHECKREV="${BASH_REMATCH[1]}"
			fi
		fi
		printf "[$(cgreen "INFO")]: ${TYPE} [$(cgreen "status")] health [$(cgreen "${HOST}")]... [$(ccyan "SERVICES")] - SUCCESS\n" 1>&2
		PING=$(ping -W 1 -c 1 "$HOST" &>/dev/null && echo 1 || echo 0)
		if [[ "$PING" == 1 ]]; then
			PRINT=$(getThumbprint "$HOST":443 thumbprint 2>/dev/null)
			CERT=$(getCertificate "$HOST":443 2>/dev/null)
		fi
		read -r -d '' JQSPEC <<-CONFIG
			{
				"type": .type,
				"hostname": "$HOST",
				"username": .username,
				"password": .password,
				"online": .online,
				"dnsfwd": "$CHECKFWD",
				"dnsrev": "$CHECKREV",
				"ping": (if "${PING}" == "1" then
					"REACHABLE"
				else
					"FAILED"
				end),
				"thumbprint": (if ("${PRINT}" | length) != 0 then
					"${PRINT}"
				else
					"FAILED"
				end),
				"certificate": "$CERT"
			}
		CONFIG
		printf "%s\n" "$(echo "$SPEC" | jq "$JQSPEC")"
	fi
}

FINAL=""
COMMA=""
for KEY in $(cat sddc.parameters | jq -c '.endpoints[]'); do
	FINAL+="$COMMA"
	FINAL+=$(buildItem "$KEY")
	COMMA=","
done
printf "[${FINAL}]" | jq --tab . >"state/state.sddc.status.json"
printf "[${FINAL}]" | jq --tab .
