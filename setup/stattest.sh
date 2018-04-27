#!/bin/bash
source drv.core

NODES=$(./drv.node.list.sh)

function getStatus {
	local NODEID=${1}
	URL="https://$HOST/api/v1/fabric/nodes/${NODEID}/status"
	printf "Retrieving [$URL]... " 1>&2
	RESPONSE=$(curl -k -b nsx-cookies.txt -w "%{http_code}" -X GET \
	-H "`grep X-XSRF-TOKEN nsx-headers.txt`" \
	-H "Content-Type: application/json" \
	"$URL" 2>/dev/null)
	isSuccess "$RESPONSE"
	echo "$HTTPBODY"
}

#  "software_version" : "2.1.0.0.0.7395502",
#  "host_node_deployment_status"

#			"name": "VMware NSX-T",
#			"link": "./info/slug/networking_security/vmware_nsx/2_x"
#		}]

FINAL=""
COMMA=""
for key in $(echo ${NODES} | jq -r '.results[] | .id'); do
	#get node
	read -r -d '' JQSPEC <<-CONFIG
		.results[]
			| select(.id=="${key}")
	CONFIG
	NODE=$(echo ${NODES} | jq -r "$JQSPEC")

	# get node status
	RESULT=$(getStatus "$key")

	# build node record
	read -r -d '' JQSPEC <<-CONFIG
		.
			| [.id, .resource_type, .display_name, .ip_addresses[0]]
	CONFIG
	NODEREC=$(echo "${NODE}" | jq --tab -r "$JQSPEC")

	# build node record
	read -r -d '' JQSPEC <<-CONFIG
		.
			| [.host_node_deployment_status, .software_version]
	CONFIG
	NODESTAT=$(echo "${RESULT}" | jq --tab -r "$JQSPEC")
	MYBLAH=$(echo "$NODEREC$NODESTAT" |jq -s '. | add')

	FINAL+="$COMMA$MYBLAH"
	#echo "$FINAL"
	COMMA=","
done
FINAL="[$FINAL]"

read -r -d '' JQSPEC <<CONFIG
	.
		| ["id", "resource_type", "display_name", "ip_address", "status", "version"]
		, ["-----", "-----", "-----", "-----", "-----"]
		, (.[] | [.[0], .[1], .[2], .[3], .[4], .[5]])
	| @csv
CONFIG
#NEWVAR=$(echo "$FINAL" | jq -r "$JQSPEC")
echo "$FINAL" | jq -r "$JQSPEC" | sed 's/"//g' | column -s ',' -t
#echo "$NEWVAR" | jq --tab .

read -r -d '' JQSPEC <<CONFIG
	.results |
		["id", "display_name", "ip_address", "origin_type", "version"]
		,["-----", "-----", "-----", "-----", "-----"]
		,(.[] | [.id, .display_name, .server, .origin_type,
			(if (.origin_properties | length) != 0 then
				(.origin_properties[] | select(.key=="version").value)
			else
				"not-registered"
			end)
		])
	| @csv
CONFIG
