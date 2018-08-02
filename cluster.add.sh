#!/bin/bash
source drv.core

URL="https://$HOST/api/v1/cluster/nodes?action=add_cluster_node"
printf "NSX create cluster node [$URL]... " 1>&2
read -r -d '' PAYLOAD <<CONFIG
{
	"display_name": "mootroller01",
	"controller_role_config": {
		"type": "AddControllerNodeSpec",
		"host_msg_client_info": {
			"shared_secret": "VMware1!"
		},
		"mpa_msg_client_info": {
			"shared_secret": "VMware1!"
		}
	}
}
CONFIG
curl -v -k -b nsx-cookies.txt -w "%{http_code}" -X POST \
-H "`grep X-XSRF-TOKEN nsx-headers.txt`" \
-H "Content-Type: application/json" \
-d "$PAYLOAD" \
"$URL"

#isSuccess "$RESPONSE" | jq --tab .
