.results? |
if (length > 0) then map({
	"id": .id,
	"resource_type": .resource_type,
	"name": .display_name,
	"admin_state": .admin_state,
	"type": .attachment.type,
	"traffic_tag": .attachment.traffic_tag
}) | sort_by(.name) else empty end
