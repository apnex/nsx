.results? |
if (length > 0) then map({
	"id": .owner_vm_id,
	"resource_type": .resource_type,
	"name": .display_name,
	"vm_id": .vm_local_id_on_host,
	"mac_address": .mac_address,
}) | sort_by(.vm_id) else empty end
