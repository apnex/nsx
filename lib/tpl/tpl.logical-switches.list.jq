.results? |
if (length > 0) then map({
	"id": .id,
	"name": .display_name,
	"vni": .vni,
	"vlan": .vlan,
	"admin_state": .admin_state
}) else empty end
