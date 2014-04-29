class deployment::neutron_config($ipaddress){

	$external_bridge_name = $::external_bridge_name
	$bridge_interface = $::bridge_interface
	$physical_network = $::physical_network

	$controller_virtual_ip = $::controller_virtual_ip

	class { 'openstack::neutron':
		db_host               => $controller_virtual_ip,
		db_name               => $::neutron_db_dbname,
		db_user               => $::neutron_db_user,
		db_password           => $::neutron_db_password,
		sql_idle_timeout      => $sql_idle_timeout,

		rabbit_host           => $controller_virtual_ip,
		rabbit_user           => $::rabbit_userid,
		rabbit_password       => $::rabbit_password,
		rabbit_hosts          => $::rabbit_hosts,
		rabbit_virtual_host   => $::rabbit_virtual_host,
		user_password         => $::neutron_user_password,

		bridge_uplinks        => ["${external_bridge_name}:${bridge_interface}"],
		bridge_mappings       => ["${physical_network}:${external_bridge_name}"],

		enable_dhcp_agent     => true,
		enable_l3_agent       => true,
		enable_metadata_agent => true,
		shared_secret         => true,
		enable_server         => true,

		enable_ovs_agent      => true,
		ovs_local_ip          => $::ovs_local_ip,
		tenant_network_type   => 'vlan',
		network_vlan_ranges   => 'physnet1:1000:2000',
		firewall_driver       => 'neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver',

		auth_url              => "http://${controller_virtual_ip}:35357/v2.0",
		bind_address          => $ipaddress,
		keystone_host         => $controller_virtual_ip,
		metadata_ip           => $ipaddress

	}


	Class['openstack::db::mysql'] -> Class['deployment::nova_config']

	class{'deployment::nova_config':
			ipaddress => $ipaddress,

	}

} # End of neutron config


