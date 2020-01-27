.results? |
if (length > 0) then map({
	"id": .id,
	"name": .display_name,
	"resource_type": .resource_type,
	"edge_cluster_id": .edge_cluster_id
}) else empty end
