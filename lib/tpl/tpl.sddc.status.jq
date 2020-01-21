. |
if (length > 0) then map({
	"type": .type,
	"name": .hostname,
	"online": .online,
	"dnsfwd": .dnsfwd,
	"dnsrev": .dnsrev,
	"ping": .ping,
	"thumbprint": .thumbprint
}) else empty end
