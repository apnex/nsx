.results | if (. != null) then map({
	"id": .id,
	"resource_type": .resource_type,
	"name": .display_name,
	"os_version": .node_deployment_info.os_version,
	"vtep_address": .node_deployment_info.discovered_ip_addresses[0]
}) else empty end
