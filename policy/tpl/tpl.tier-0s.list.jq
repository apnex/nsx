.results? |
if (length > 0) then map({
	"id": .id,
	"resource_type": .resource_type,
	"name": .display_name,
	"ha_mode": .ha_mode
}) | sort_by(.name) else empty end
