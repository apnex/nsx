{
	"deployment_requests": [
		{
			"roles": [
				"CONTROLLER"
			],
			"form_factor": "SMALL",
			"user_settings": {
				"cli_password": "VMware1!",
				"root_password": "VMware1!"
			},
			"deployment_config": {
				"placement_type": "VsphereClusterNodeVMDeploymentConfig",
				"vc_id": "16844987-a81e-4beb-ab9a-41d36aa2cda6",
				"allow_ssh_root_login": true,
				"enable_ssh": true,
				"management_network_id": "dvportgroup-62",
				"hostname": "controller-1",
				"compute_id": "domain-c7",
				"storage_id": "datastore-11",
				"default_gateway_addresses": [
					"172.16.10.1"
				],
				"management_port_subnets": [
					{
						"ip_addresses": [
							"172.16.10.17"
						],
						"prefix_length": "24"
					}
				]
			}
		}
	],
	"clustering_config": {
		"clustering_type": "ControlClusteringConfig",
		"shared_secret": "VMware1!",
		"join_to_existing_cluster": true
	}
}
