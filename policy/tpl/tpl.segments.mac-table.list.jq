#.results? |
if (length > 0) then map({
	"mac_address": .mac_address,
	"mac_type": .mac_type,
	"port_id": .port_id,
	"transport_node_id": .transport_node_id
}) | sort_by(.name) else empty end
