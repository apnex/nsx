.results? |
if (length > 0)
	then map({
		"id": .id,
		"name": .display_name,
		"resource_type": .resource_type
	})
| sort_by(.name) else empty end
