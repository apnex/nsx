{
	"node_id": "0df0cb1c-ad3e-48be-a60a-1b2c864f9eb7",
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
					"device_name": "vmnic1",
					"uplink_name": "uplink2"
				}
			],
			"static_ip_pool_id": "08d434d4-e924-4b03-9370-421885085efc"
		}
	],
	"host_switch_spec": {
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
						"device_name": "vmnic1",
						"uplink_name": "uplink2"
					},
					{
						"device_name": "vmnic0",
						"uplink_name": "uplink1"
					}
				],
				"is_migrate_pnics": false,
				"ip_assignment_spec": {
					"ip_pool_id": "08d434d4-e924-4b03-9370-421885085efc",
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
			"transport_zone_id": "15d4872a-2b0d-4381-9ec8-f95824acb125",
			"transport_zone_profile_ids": [
				{
					"resource_type": "BfdHealthMonitoringProfile",
					"profile_id": "52035bb3-ab02-4a08-9884-18631312e50a"
				}
			]
		},
		{
			"transport_zone_id": "910d546c-56f0-400c-a89a-99fd18368673",
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
		"managed_by_server": "172.16.0.13",
		"discovered_node_id": "d4610b08-9348-4aca-861d-680da0c1f1a5:host-817",
		"resource_type": "HostNode",
		"id": "0df0cb1c-ad3e-48be-a60a-1b2c864f9eb7",
		"display_name": "tn-esx01.lab",
		"external_id": "0df0cb1c-ad3e-48be-a60a-1b2c864f9eb7",
		"fqdn": "esx01.lab",
		"ip_addresses": [
			"172.16.10.101"
		],
		"discovered_ip_addresses": [
			"192.168.12.10",
			"172.16.10.101",
			"169.254.1.1"
		],
		"_create_user": "admin",
		"_create_time": 1574208349195,
		"_last_modified_user": "admin",
		"_last_modified_time": 1574226483920,
		"_protection": "NOT_PROTECTED",
		"_revision": 8
	},
	"is_overridden": false,
	"resource_type": "TransportNode",
	"id": "0df0cb1c-ad3e-48be-a60a-1b2c864f9eb7",
	"display_name": "tn-esx01.lab",
	"description": "NSX configured Test Transport Node",
	"_create_user": "admin",
	"_create_time": 1574208349306,
	"_last_modified_user": "admin",
	"_last_modified_time": 1574226483926,
	"_system_owned": false,
	"_protection": "NOT_PROTECTED",
	"_revision": 8
}
