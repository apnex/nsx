.results? |
if (length > 0) then map({
	"id": .id,
	"name": .display_name,
	"resource_type": .resource_type,
	"dhcp_server_id": .ipv4_dhcp_server.dhcp_server_ip,
	"logical_port": .attached_logical_port_id
}) else empty end
