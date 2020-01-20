.results? |
if (length > 0) then map({
	"id": .mac_address,
	"type": .mac_type
}) else empty end
