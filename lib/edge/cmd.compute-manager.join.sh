#!/bin/bash
if [[ $0 =~ ^(.*)/([^/]+)$ ]]; then ## offload to drv.core?
	WORKDIR=${BASH_REMATCH[1]}
	if [[ ${BASH_REMATCH[2]} =~ ^[^.]+[.](.+)[.]sh$ ]]; then
		TYPE=${BASH_REMATCH[1]}
	fi
fi
source ${WORKDIR}/drv.core
source ${WORKDIR}/drv.nsx.client
source ${WORKDIR}/drv.vsp.client

## temp - move back to drv core - needed for : (colon) separation of {2} values
PAYLOAD=$(echo -n | openssl s_client -connect "${VSPHOST}":443 2>/dev/null)
PRINT=$(echo "$PAYLOAD" | openssl x509 -noout -fingerprint -sha256)
REGEX='^(.*)=(([0-9A-Fa-f]{2}[:])+([0-9A-Fa-f]{2}))$'
if [[ $PRINT =~ $REGEX ]]; then
	TYPE=${BASH_REMATCH[1]}
	VSPPRINT=${BASH_REMATCH[2]}
fi

function makeBody {
	read -r -d '' PAYLOAD <<-CONFIG
	{
		"server": "$VSPHOST",
		"display_name": "$VSPHOST",
		"origin_type": "vCenter",
		"credential" : {
			"credential_type" : "UsernamePasswordLoginCredential",
			"username": "$VSPUSER",
			"password": "$VSPPASS",
			"thumbprint": "$VSPPRINT"
		}
	}
	CONFIG
	echo "${PAYLOAD}"
}

if [[ -n "${VSPHOST}" && "${VSPUSER}" && "${VSPPASS}" && "${VSPPRINT}" ]]; then
 	BODY=$(makeBody)
	URL="https://$NSXHOST/api/v1/fabric/compute-managers"
	printf "[$(cgreen "INFO")]: nsx [$(cgreen "join")] compute-manager [$(cgreen "$VSPHOST")] [$(cgreen "$URL")]... " 1>&2
	nsxPost "${URL}" "${BODY}"
else
	printf "[$(cgreen "ERROR")]: Command usage: $(cgreen "compute-manager.join") $(ccyan "<transport-nodes.name> <node.id>")\n" 1>&2
fi

