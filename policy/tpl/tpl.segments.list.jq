.results? |
if (length > 0) then map({
	"id": .id,
	"resource_type": .resource_type,
	"name": .display_name,
	"type": .type,
	"admin_state": .admin_state,
}) | sort_by(.name) else empty end
