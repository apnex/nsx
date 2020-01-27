{
	"node_id": "4de31359-6846-4e3f-b3b7-83fa2bf6a308",
	"host_switches": [
		{
			"host_switch_name": "hs-fabric",
			"host_switch_profile_ids": [
				{
					"key": "UplinkHostSwitchProfile",
					"value": "f48d95b9-f3cd-49d3-9778-755cb486cc2b"
				},
				{
					"key": "LldpHostSwitchProfile",
					"value": "9e0b4d2d-d155-4b4b-8947-fbfe5b79f7cb"
				}
			],
			"pnics": [
				{
					"device_name": "fp-eth0",
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
						"value": "f48d95b9-f3cd-49d3-9778-755cb486cc2b"
					},
					{
						"key": "LldpHostSwitchProfile",
						"value": "9e0b4d2d-d155-4b4b-8947-fbfe5b79f7cb"
					}
				],
				"pnics": [
					{
						"device_name": "fp-eth0",
						"uplink_name": "uplink1"
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
		"deployment_type": "VIRTUAL_MACHINE",
		"deployment_config": {
			"vm_deployment_config": {
				"vc_id": "09c7e969-e0f4-4a7e-a880-cf710c9669ec",
				"compute_id": "domain-c7",
				"storage_id": "datastore-55",
				"host_id": "host-54",
				"management_network_id": "dvportgroup-22",
				"management_port_subnets": [
					{
						"ip_addresses": [
							"172.16.10.19"
						],
						"prefix_length": 24
					}
				],
				"default_gateway_addresses": [
					"172.16.10.1"
				],
				"hostname": "nsx-edge02",
				"data_network_ids": [
					"dvportgroup-23",
					"dvportgroup-23",
					"dvportgroup-23"
				],
				"ntp_servers": [
					"172.16.10.1"
				],
				"dns_servers": [
					"172.16.10.1"
				],
				"enable_ssh": true,
				"allow_ssh_root_login": true,
				"placement_type": "VsphereDeploymentConfig"
			},
			"form_factor": "SMALL",
			"node_user_settings": {
				"cli_username": "admin"
			}
		},
		"node_settings": {
			"hostname": "nsx-edge02",
			"ntp_servers": [
				"172.16.10.1"
			],
			"dns_servers": [
				"172.16.10.1"
			],
			"enable_ssh": true,
			"allow_ssh_root_login": true
		},
		"resource_type": "EdgeNode",
		"id": "4de31359-6846-4e3f-b3b7-83fa2bf6a308",
		"display_name": "tn-edge02",
		"external_id": "4de31359-6846-4e3f-b3b7-83fa2bf6a308",
		"ip_addresses": [
			"172.16.10.19"
		],
		"_create_user": "admin",
		"_create_time": 1580117211117,
		"_last_modified_user": "admin",
		"_last_modified_time": 1580118047228,
		"_system_owned": false,
		"_protection": "NOT_PROTECTED",
		"_revision": 3
	},
	"is_overridden": false,
	"failure_domain_id": "4fc1e3b0-1cd4-4339-86c8-f76baddbaafb",
	"resource_type": "TransportNode",
	"id": "4de31359-6846-4e3f-b3b7-83fa2bf6a308",
	"display_name": "tn-edge02",
	"description": "NSX configured Test Transport Node",
	"_create_user": "admin",
	"_create_time": 1580117211184,
	"_last_modified_user": "admin",
	"_last_modified_time": 1580118047256,
	"_system_owned": false,
	"_protection": "NOT_PROTECTED",
	"_revision": 2
}
