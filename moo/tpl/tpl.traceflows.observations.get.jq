.results? |
if (length > 0) then map({
	"resource_type": .resource_type,
	"transport_node_name": .transport_node_name,
	"transport_node_type": .transport_node_type,
	"component_name": .component_name,
	"component_type": .component_type,
	"component_detail": (
		if (.resource_type == "TraceflowObservationForwarded") and (.remote_ip_address | length) != 0 then
			"Remote: " + .remote_ip_address
		elif (.resource_type == "TraceflowObservationReceived") and (.remote_ip_address | length) != 0 then
			"Remote: " + .remote_ip_address
		elif (.resource_type == "TraceflowObservationForwardedLogical") and (.acl_rule_id | length) != 0 then
			"Rule-id: " + (.acl_rule_id | tostring)
		else "" end
	)
}) else "" end
