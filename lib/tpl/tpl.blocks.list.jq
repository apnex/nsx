.results? |
if (length > 0) then map({
	"id": .id,
	"name": .display_name,
	"cidr": .cidr
}) else empty end
