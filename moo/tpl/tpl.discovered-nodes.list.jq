.results | if (. != null) then map({
	"id": .external_id,
	"name": .display_name,
	"resource_type": .resource_type,
	"ip_addresses": .ip_addresses[0]
}) else empty end
