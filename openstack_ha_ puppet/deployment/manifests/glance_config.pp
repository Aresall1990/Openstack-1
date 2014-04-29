class deployment::glance_config($ipaddress){

	$controller_virtual_ip = $::controller_virtual_ip

    class {'openstack::glance':
		user_password            => $::glance_user_password,
		db_password              => $::glance_db_password,
		db_host                  => $controller_virtual_ip,
		keystone_host            => $controller_virtual_ip,
		sql_idle_timeout         => $::sql_idle_timeout,
		registry_host            => $controller_virtual_ip,
		swift_store_user         => 'services:swift',
		swift_store_key          => $::swift_store_key,
		bind_host                => $ipaddress,
		backend                  => 'swift',
		db_user                  => $::glance_db_user,
		db_name                  => $::glance_db_dbname,
		swift_store_auth_address => "http://${controller_virtual_ip}:5000/v2.0/",
	}


	Class['openstack::db::mysql'] -> Class['deployment::neutron_config']

	class{'deployment::neutron_config':
			ipaddress => $ipaddress,

	}

} # end of glance_config class

