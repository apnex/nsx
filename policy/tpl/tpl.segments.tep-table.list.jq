.results? |
if (length > 0) then map({
	"vtep_ip": .tep_ip,
	"vtep_mac_address": .tep_mac_address,
}) | sort_by(.name) else empty end
