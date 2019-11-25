#!/bin/bash
#!/bin/bash
if [[ $0 =~ ^(.*)/[^/]+$ ]]; then
	WORKDIR=${BASH_REMATCH[1]}
fi
source ${WORKDIR}/drv.core
source ${WORKDIR}/drv.nsx.client

function checkNodeType {
	local NODE=${1}
	PAYLOAD=$(./drv.nodes.list.sh 2>/dev/null)
	read -r -d '' JQSPEC <<-CONFIG
		.results[] | select(.id=="${NODE}")
	CONFIG

	# add a check to see that node exists!
	EDGENODE=$(echo "$PAYLOAD" | jq -r "$JQSPEC")
	NODETYPE=$(echo "$EDGENODE" | jq -r ".resource_type")
	NODENAME=$(echo "$EDGENODE" | jq -r ".display_name")
	if [[ "$NODETYPE" == "EdgeNode" ]]; then
		read -r -d '' JQSPEC <<-CONFIG
			.deployment_config.vm_deployment_config.vc_id
		CONFIG
		NODEVC=$(echo "$EDGENODE" | jq -r "$JQSPEC")
		read -r -d '' JQSPEC <<-CONFIG
			.results[] | select(.id=="${NODEVC}")
		CONFIG
		CMANAGER=$(./drv.compute-manager.list.sh 2>/dev/null | jq -r "$JQSPEC | .id")
		if [[ -n "${CMANAGER}" ]]; then
			printf "[$(cgreen "INFO")]: found [$(cgreen "compute-manager")] name [$(cgreen "${VSPHOST}")] id [$(cgreen "${CMANAGER}")]\n" 1>&2
		else
			printf "[$(corange "WARNING")]: could not find [$(cgreen "compute-manager")] id [$(cgreen "${NODEVC}")]\n" 1>&2
			printf "[$(corange "WARNING")]: EdgeNode vm [$(cgreen "${NODENAME}")] is now orphaned and will need to be manually deleted\n" 1>&2
		fi
	else
		printf "[$(corange "WARNING")]: HostNode [$(cgreen "${NODENAME}")] is now orphaned and will need to be manually unprepared\n" 1>&2
	fi
}

ID=${1}
if [[ -n "${ID}" ]]; then
	if [[ -n "${NSXHOST}" ]]; then
		checkNodeType "${ID}"
		ITEM="fabric/nodes"
		CALL="/${ID}"
		URL=$(buildURL "${ITEM}${CALL}")
		if [[ -n "${URL}" ]]; then
			printf "[$(cgreen "INFO")]: nsx [$(cgreen "delete")] ${ITEM} [$(cgreen "$URL")]... " 1>&2
			#nsxDelete "${URL}" "unprepare_host=false"
			nsxDelete "${URL}" "unprepare_host=true"
		fi
	fi
else
	printf "[$(corange "ERROR")]: command usage: $(cgreen "node.delete") $(ccyan "<uuid>")\n" 1>&2
fi
