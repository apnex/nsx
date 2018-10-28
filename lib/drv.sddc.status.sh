#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.core
if [ -z ${SDDCDIR} ]; then
	SDDCDIR=${WORKDIR}
fi

PARAMS=$(cat ${SDDCDIR}/sddc.parameters)
DOMAIN=$(echo "$PARAMS" | jq -r .domain)
DNS=$(echo "$PARAMS" | jq -r .dns)

# 1 get the parameters
# 2 get API endpoint (via drv.client?)
# 3 resolve endpoint
# 3 ping the hostname || or if IP - ping the IP address
# 4 get the SSL thumbprint
# 5 attempt auth? maybe default command
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
			if [[ ! "$HOST" =~ [.] ]]; then
				HOST+=".$DOMAIN"
			fi
			if [[ "$(host -t A -W 1 "$HOST" "$DNS" 2>/dev/null)" =~ ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})$ ]]; then
				CHECKFWD="${BASH_REMATCH[1]}"
			fi
		fi

		if [[ -n "$CHECKFWD" ]]; then
			if [[ "$(host -t SRV -W 1 "$CHECKFWD" "$DNS" 2>/dev/null)" =~ ([0-9a-z.-]+)$ ]]; then
				CHECKREV="${BASH_REMATCH[1]}"
			fi
		fi
		printf "[$(cgreen "INFO")]: ${TYPE} [$(cgreen "status")] health [$(cgreen "${HOST}")]... [$(ccyan "SERVICES")] - SUCCESS\n" 1>&2
		local PING=$(ping -W 1 -c 1 "$HOST" &>/dev/null && echo 1 || echo 0)
		local PRINT=$(getThumbprint "$HOST":443 thumbprint 2>/dev/null)
		if [[ -n "${PRINT}" ]]; then
			local CERT=$(getCertificate "$HOST":443 2>/dev/null)
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

# convert to jq merge
FINAL=""
COMMA=""
for KEY in $(echo "$PARAMS" | jq -c '.endpoints[]'); do
	FINAL+="$COMMA"
	FINAL+=$(buildItem "$KEY")
	COMMA=","
done
printf "[${FINAL}]" | jq --tab . >"${STATEDIR}/sddc.status.json"
printf "[${FINAL}]" | jq --tab .
