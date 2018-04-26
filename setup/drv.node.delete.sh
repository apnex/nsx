#!/bin/bash
source drv.core
NODE=$1

function deleteNode {
	URL="https://$HOST/api/v1/fabric/nodes/${1}"
	printf "DELETE node [${1}] - call [$URL]... " 1>&2
	RESPONSE=$(curl -k -b cookies.txt -w "%{http_code}" -G -X DELETE \
	-H "`grep X-XSRF-TOKEN headers.txt`" \
	--data-urlencode "unprepare_host=false" \
	"$URL" 2>/dev/null)
	isSuccess "$RESPONSE"
}

function checkNodeType {
	PAYLOAD=$(./drv.node.list.sh 2>/dev/null)
	read -r -d '' JQSPEC <<-CONFIG
		.results[]
			| select(.id=="${1}")
	CONFIG
	# add a check to see that node exists!
	EDGENODE=$(echo "$PAYLOAD" | jq -r "$JQSPEC")
	NODETYPE=$(echo "$EDGENODE" | jq -r ".resource_type")
	NODENAME=$(echo "$EDGENODE" | jq -r ".display_name")
	if [[ "$NODETYPE" == "EdgeNode" ]]; then
		#echo "$NODETYPE"
		read -r -d '' JQSPEC <<-CONFIG
			.deployment_config.vm_deployment_config.vc_id
		CONFIG
		NODEVC=$(echo "$EDGENODE" | jq -r "$JQSPEC")
		#echo "$NODEVC"
		read -r -d '' JQSPEC <<-CONFIG
			.results[]
				| select(.id=="${NODEVC}")
		CONFIG
		CMANAGER=$(./drv.cmanager.list.sh | jq -r "$JQSPEC | .id")
		if [[ -n "${CMANAGER}" ]]; then
			printf "INFO: found [compute-manager] with name [${VCHOST}] id [${CMANAGER}]\n" 1>&2
			deleteNode "${NODE}"
		else
			printf "WARNING: Could not find [compute-manager] with id [${NODEVC}]\n" 1>&2
			deleteNode "${NODE}"
			printf "WARNING: EdgeNode vm [${NODENAME}] is now orphaned and will need to be manually deleted\n" 1>&2
		fi
	else
		deleteNode "${NODE}"
		printf "WARNING: HostNode [${NODENAME}] is now orphaned and will need to be manually unprepared\n" 1>&2
	fi
}

if [[ -n "${NODE}" ]]; then
	checkNodeType "${NODE}"
else
	printf "ERROR: command usage: ${ORANGE}node.delete${LIGHTCYAN} <nodeid>${NC}\n" 1>&2
fi
