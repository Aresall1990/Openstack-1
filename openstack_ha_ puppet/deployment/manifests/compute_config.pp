class deployment::compute_config($ipaddress){
	
	$external_bridge_name = $::external_bridge_name
	$bridge_interface = $::bridge_interface
	$physical_network = $::physical_network
	$controller_virtual_ip = $::controller_virtual_ip

	class {'openstack::compute':
		internal_address              => $ipaddress,
		# Required Nova
		nova_user_password            => $::nova_db_password,
		# Required Rabbit
		rabbit_password               => $::rabbit_password,
		# DB
		nova_db_password             => $::nova_db_password,
		db_host                      => $::controller_virtual_ip,
		# Nova Database
		nova_db_user                 => $::nova_db_user,
		nova_db_name                 => $::nova_db_dbname,
		# Network
		private_interface             => $::private_interface,
		public_interface              => $::public_interface,
		fixed_range                   => '10.0.0.0/8',
		network_manager               => 'nova.network.manager.FlatDHCPManager',

		# Neutron
		neutron                       => true,
		neutron_user_password         => $::neutron_user_password,
		neutron_admin_tenant_name     => 'services',
		neutron_admin_user            => $::neutron_admin_user,
		enable_ovs_agent              => true,
		enable_l3_agent               => true,
		enable_dhcp_agent             => true,
		neutron_auth_url              => "http://${controller_virtual_ip}:35357/v2.0",
		keystone_host                 => $controller_virtual_ip,
		neutron_host                  => $controller_virtual_ip,
		ovs_enable_tunneling          => true,
		ovs_local_ip                  => $::ovs_local_ip,
		neutron_firewall_driver       => 'neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver',
		bridge_mappings               => ["${physical_network}:${external_bridge_name}"],
		bridge_uplinks                => ["${external_bridge_name}:${bridge_interface}"],
		security_group_api            => 'neutron',
		# Nova
		nova_admin_tenant_name        => 'services',
		nova_admin_user               => $::nova_admin_user,
		purge_nova_config             => false,
		libvirt_vif_driver            => 'nova.virt.libvirt.vif.LibvirtGenericVIFDriver',
		# Rabbit
		rabbit_host                   => $controller_virtual_ip,
		rabbit_hosts                  => $::rabbit_hosts,
		rabbit_user                   => $::rabbit_userid,
		rabbit_virtual_host           => '/',
		# Glance
		glance_api_servers            => "${controller_virtual_ip}:9292",
		# Virtualization
		libvirt_type                  => 'kvm',
		# VNC
		vnc_enabled                   => true,
		vncproxy_host                 => $controller_virtual_ip,
		vncserver_listen              => $ipaddress,
		# cinder / volumes
		manage_volumes                => true,
		cinder_volume_driver          => 'iscsi',
		cinder_db_password            => $::cinder_db_password,
		cinder_db_user                => $::cinder_db_user,
		cinder_db_name                => $::cinder_db_dbname,
		volume_group                  => 'cinder-volumes',
		iscsi_ip_address              => $ipaddress,
		setup_test_volume             => true,
		cinder_rbd_user               => 'volumes',
		cinder_rbd_pool               => 'volumes',
		cinder_rbd_secret_uuid        => false,
		# General
		migration_support             => false,
		verbose                       => false,
		force_config_drive            => false,
		enabled                       => true,
	}
} # End of class compute config
