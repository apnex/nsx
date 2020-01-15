. | if (. != null) then map({
	"id": .id,
	"name": .name,
	"vni": .vni,
	"vlan": .vlan,
	"admin_state": .admin_state,
	"state" : .state
}) else "" end
