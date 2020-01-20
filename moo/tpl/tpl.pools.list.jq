.results? |
if (length > 0) then map({
	"id": .id,
	"name": .display_name,
	"cidr": .subnets[0].cidr
}) else empty end
