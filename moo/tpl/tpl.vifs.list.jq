.results? |
if (length > 0) then map({
	"id": .lport_attachment_id,
	"name": .device_name,
	"resource_type": .resource_type,
	"device_key": .device_key,
	"ip_addresses": [.ip_address_info[].ip_addresses[]] | join(","),
	"mac_address": .mac_address,
	"owner_vm_id": .owner_vm_id
}) else "" end
