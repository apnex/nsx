{
	"node_id": "e57c57de-50ad-4a8a-bed0-c4055c3c4ffe",
	"host_switches": [
		{
			"host_switch_name": "hs-fabric",
			"host_switch_profile_ids": [
				{
					"key": "UplinkHostSwitchProfile",
					"value": "5f8dfef2-fa80-4f7e-bc23-70692cb0dbba"
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
			"static_ip_pool_id": "495e5dcc-3478-4256-ae4d-04e7dc1ad83e"
		}
	],
	"host_switch_spec": {
		"host_switches": [
			{
				"host_switch_name": "hs-fabric",
				"host_switch_profile_ids": [
					{
						"key": "UplinkHostSwitchProfile",
						"value": "5f8dfef2-fa80-4f7e-bc23-70692cb0dbba"
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
					},
					{
						"device_name": "vmnic1",
						"uplink_name": "uplink2"
					}
				],
				"is_migrate_pnics": false,
				"ip_assignment_spec": {
					"ip_pool_id": "495e5dcc-3478-4256-ae4d-04e7dc1ad83e",
					"resource_type": "StaticIpPoolSpec"
				},
				"cpu_config": [],
				"vmk_install_migration": [],
				"pnics_uninstall_migration": [],
				"vmk_uninstall_migration": [],
				"not_ready": false
			}
		],
		"resource_type": "StandardHostSwitchSpec"
	},
	"transport_zone_endpoints": [
		{
			"transport_zone_id": "5e762ee6-318d-4fb8-b579-5d7725c14589",
			"transport_zone_profile_ids": [
				{
					"resource_type": "BfdHealthMonitoringProfile",
					"profile_id": "52035bb3-ab02-4a08-9884-18631312e50a"
				}
			]
		},
		{
			"transport_zone_id": "fa69cc58-1731-4261-8d43-1fa8d4842784",
			"transport_zone_profile_ids": [
				{
					"resource_type": "BfdHealthMonitoringProfile",
					"profile_id": "52035bb3-ab02-4a08-9884-18631312e50a"
				}
			]
		}
	],
	"maintenance_mode": "DISABLED",
	"node_deployment_info": {
		"os_type": "ESXI",
		"os_version": "6.7.0",
		"managed_by_server": "172.16.100.45",
		"discovered_node_id": "09c7e969-e0f4-4a7e-a880-cf710c9669ec:host-115",
		"resource_type": "HostNode",
		"id": "e57c57de-50ad-4a8a-bed0-c4055c3c4ffe",
		"display_name": "tn-esx03.lab",
		"external_id": "e57c57de-50ad-4a8a-bed0-c4055c3c4ffe",
		"fqdn": "esx03.lab",
		"ip_addresses": [
			"172.16.10.103"
		],
		"discovered_ip_addresses": [
			"172.16.10.103",
			"169.254.1.1",
			"192.168.12.13"
		],
		"_create_user": "admin",
		"_create_time": 1579500265415,
		"_last_modified_user": "admin",
		"_last_modified_time": 1581219053057,
		"_protection": "NOT_PROTECTED",
		"_revision": 5
	},
	"is_overridden": false,
	"resource_type": "TransportNode",
	"id": "e57c57de-50ad-4a8a-bed0-c4055c3c4ffe",
	"display_name": "tn-esx03.lab",
	"description": "NSX configured Test Transport Node",
	"_create_user": "admin",
	"_create_time": 1579500265684,
	"_last_modified_user": "admin",
	"_last_modified_time": 1581219053100,
	"_system_owned": false,
	"_protection": "NOT_PROTECTED",
	"_revision": 5
}
