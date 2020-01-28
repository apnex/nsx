.results? |
if (length > 0) then map({
	"id": .id,
	"name": .display_name,
	"deployment_type": .deployment_type,
	"members": (.members? |
		if (length > 0) then
			map(.transport_node_id) | join(",")
		else "" end
	)
}) else empty end
