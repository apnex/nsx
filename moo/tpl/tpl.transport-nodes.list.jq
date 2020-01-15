.results? |
if (length > 0) then map({
	"id": .id,
	"name": .display_name,
	"resource_type": .node_deployment_info.resource_type,
	"ip_address": .node_deployment_info.ip_addresses[0],
	"os_type": .node_deployment_info.os_type,
	"os_version": .node_deployment_info.os_version,
	"host_switch": .host_switch_spec.host_switches[0].host_switch_name,
	"pnics": (.host_switch_spec.host_switches[0]? |
		if (length > 0) then
			.pnics | map(
				[.device_name, .uplink_name] | join(":")
			) | join(",")
		else "" end
	)
}) else "" end
