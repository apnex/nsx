#!/bin/bash
source drv.core
ID=${1}

function deleteNode {
	URL="https://$HOST/api/v1/fabric/nodes/${1}"
	printf "DELETE node [${1}] - call [$URL]... " 1>&2
	RESPONSE=$(curl -k -b nsx-cookies.txt -w "%{http_code}" -G -X DELETE \
	-H "`grep X-XSRF-TOKEN nsx-headers.txt`" \
	--data-urlencode "unprepare_host=false" \
	"$URL" 2>/dev/null)
	isSuccess "$RESPONSE"
}

function checkNodeType {
	local NODE=${1}
	PAYLOAD=$(./drv.node.list.sh 2>/dev/null)
	read -r -d '' JQSPEC <<-CONFIG
		.results[]
			| select(.id=="${NODE}")
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
		CMANAGER=$(./drv.cmanager.list.sh 2>/dev/null | jq -r "$JQSPEC | .id")
		if [[ -n "${CMANAGER}" ]]; then
			printf "[$(cgreen "INFO")]: found [$(cgreen "compute-manager")] name [$(cgreen "${VCHOST}")] id [$(cgreen "${CMANAGER}")]\n" 1>&2
		else
			printf "[$(corange "WARNING")]: could not find [$(cgreen "compute-manager")] id [$(cgreen "${NODEVC}")]\n" 1>&2
			printf "[$(corange "WARNING")]: EdgeNode vm [$(cgreen "${NODENAME}")] is now orphaned and will need to be manually deleted\n" 1>&2
		fi
	else
		printf "[$(corange "WARNING")]: HostNode [$(cgreen "${NODENAME}")] is now orphaned and will need to be manually unprepared\n" 1>&2
	fi
}

if [[ -n "${ID}" ]]; then
	if [[ -n "${HOST}" ]]; then
		checkNodeType "${ID}"
		ITEM="fabric/nodes"
		CALL="/${ID}"
		URL=$(buildURL "${ITEM}${CALL}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "delete")] ${ITEM} - [$(cgreen "$URL")]... " 1>&2
			rDelete "${URL}" "unprepare_host=false"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "node.delete") $(ccyan "<uuid>")\n" 1>&2
fi
