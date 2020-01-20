.results | if (. != null) then map({
	"id": .id,
	"name": .display_name,
	"host_switch_name": .host_switch_name,
	"transport_type": .transport_type
}) else empty end
