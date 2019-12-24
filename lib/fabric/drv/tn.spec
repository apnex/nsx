{
	"node_id": "b3754272-290a-4bb9-9905-906b1c66cb4a",
	"host_switches": [
		{
			"host_switch_name": "hs-fabric",
			"host_switch_profile_ids": [
				{
					"key": "UplinkHostSwitchProfile",
					"value": "d4a26941-197f-42e0-858f-7a18d989a6c4"
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
			"static_ip_pool_id": "b6153ed3-2705-46cb-a834-48d21eaf5eb2"
		}
	],
	"host_switch_spec": {
		"host_switches": [
			{
				"host_switch_name": "hs-fabric",
				"host_switch_profile_ids": [
					{
						"key": "UplinkHostSwitchProfile",
						"value": "d4a26941-197f-42e0-858f-7a18d989a6c4"
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
					"ip_pool_id": "b6153ed3-2705-46cb-a834-48d21eaf5eb2",
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
			"transport_zone_id": "62bc487e-5ba6-4a3d-a34c-4ba46523c073",
			"transport_zone_profile_ids": [
				{
					"resource_type": "BfdHealthMonitoringProfile",
					"profile_id": "52035bb3-ab02-4a08-9884-18631312e50a"
				}
			]
		},
		{
			"transport_zone_id": "739002c3-61e5-46d6-8ea6-2209c13e59fe",
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
		"managed_by_server": "172.16.101.131",
		"discovered_node_id": "debabe33-0689-4328-b67a-7c169c71e6a7:host-55",
		"resource_type": "HostNode",
		"id": "b3754272-290a-4bb9-9905-906b1c66cb4a",
		"display_name": "tn-esx02",
		"external_id": "b3754272-290a-4bb9-9905-906b1c66cb4a",
		"fqdn": "esx02.lab",
		"ip_addresses": [
			"172.16.10.102"
		],
		"discovered_ip_addresses": [
			"172.16.10.102",
			"192.168.12.11",
			"169.254.1.1"
		],
		"_create_user": "admin",
		"_create_time": 1577146628854,
		"_last_modified_user": "admin",
		"_last_modified_time": 1577152781646,
		"_protection": "NOT_PROTECTED",
		"_revision": 3
	},
	"is_overridden": false,
	"resource_type": "TransportNode",
	"id": "b3754272-290a-4bb9-9905-906b1c66cb4a",
	"display_name": "tn-esx02",
	"description": "NSX configured Test Transport Node",
	"_create_user": "admin",
	"_create_time": 1577146629163,
	"_last_modified_user": "admin",
	"_last_modified_time": 1577152781670,
	"_system_owned": false,
	"_protection": "NOT_PROTECTED",
	"_revision": 3
}
