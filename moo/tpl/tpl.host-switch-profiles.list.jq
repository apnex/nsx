.results | if (. != null) then map({
	"id": .id,
	"name": .display_name,
	"resource_type": .resource_type,
	"transport_vlan": .transport_vlan,
	"mtu": .mtu
}) else "" end
