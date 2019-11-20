{
	"node_id": "51e864d4-2fb2-4928-9d89-77c441b2f578",
	"maintenance_mode": "DISABLED",
	"node_deployment_info": {
		"os_type": "ESXI",
		"os_version": "6.7.0",
		"managed_by_server": "172.16.0.13",
		"discovered_node_id": "d4610b08-9348-4aca-861d-680da0c1f1a5:host-813",
		"resource_type": "HostNode",
		"id": "51e864d4-2fb2-4928-9d89-77c441b2f578",
		"display_name": "tn-esx02.lab",
		"external_id": "51e864d4-2fb2-4928-9d89-77c441b2f578",
		"fqdn": "esx02.lab",
		"ip_addresses": [
			"172.16.10.102"
		],
		"discovered_ip_addresses": [
			"192.168.12.10",
			"172.16.10.102",
			"169.254.1.1"
		],
		"_create_user": "admin",
		"_create_time": 1574132307545,
		"_last_modified_user": "admin",
		"_last_modified_time": 1574138986268,
		"_protection": "NOT_PROTECTED",
		"_revision": 3
	},
	"is_overridden": false,
	"id": "51e864d4-2fb2-4928-9d89-77c441b2f578",
	"resource_type": "TransportNode",
	"display_name": "tn-esx02.lab",
	"host_switches": [
		{
			"host_switch_name": "hs-fabric",
			"host_switch_profile_ids": [
				{
					"key": "UplinkHostSwitchProfile",
					"value": "972087f9-07a8-4969-967a-5c8405c3cde2"
				},
				{
					"key": "LldpHostSwitchProfile",
					"value": "9e0b4d2d-d155-4b4b-8947-fbfe5b79f7cb"
				},
				{
					"key": "NiocProfile",
					"value": "8cb3de94-2834-414c-b07d-c034d878db56"
				}
			],
			"pnics": [
				{
					"device_name": "vmnic0",
					"uplink_name": "uplink1"
				}
			],
			"static_ip_pool_id": "08d434d4-e924-4b03-9370-421885085efc"
		}
	],
	"description": "NSX configured Test Transport Node",
	"_create_user": "admin",
	"_create_time": 1574132307694,
	"_last_modified_user": "admin",
	"_last_modified_time": 1574138986275,
	"_system_owned": false,
	"_protection": "NOT_PROTECTED",
	"_revision": 3
}
