.results | if (. != null) then map({
	"id": .id,
	"name": .display_name,
	"resource_type": .resource_type,
	"logical_switch_id": .logical_switch_id,
	"admin_state": .admin_state,
	"attachment_type": .attachment.attachment_type
}) else "" end
