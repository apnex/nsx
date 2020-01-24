.results | if (. != null) then map({
	"id": .id,
	"name": .display_name,
	"deployment_type": .deployment_type,
	"members": (.members? |
		if (length > 0) then
			.[] | .transport_node_id
		else "" end
	)
}) else empty end
