.results | if (. != null) then map({
	"id": .id,
	"name": .display_name,
	"router_type": .router_type,
	"ha_mode": .high_availability_mode
}) | sort_by(.name) else empty end
