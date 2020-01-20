.results? |
if (length > 0) then map({
	"id": .id,
	"name": .display_name,
	"server": .server,
	"origin": .origin_type,
	"version": (
		if (.origin_properties | length) != 0 then
			(.origin_properties[] | select(.key=="version").value)
		else
			"not-registered"
		end
	)
}) sort_by(.id) else empty end
