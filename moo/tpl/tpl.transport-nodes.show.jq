. | if (. != null) then map({
	"id": .id,
	"name": .name,
	"resource_type": .resource_type,
	"ip_address": .ip_address,
	"host_switch": .host_switch,
	"status": .status,
	"state": .state,
	"software_version": .software_version
}) else "" end
