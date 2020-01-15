.results | if (. != null) then map({
	"id": .id,
	"operation_state": .operation_state,
	"request_status": .request_status
}) else "" end
