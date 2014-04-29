class deployment::cinder_config($ipaddress){

	$controller_virtual_ip = $::controller_virtual_ip

	class { 'openstack::cinder::controller':
		bind_host          => $ipaddress,
		sql_idle_timeout   => '30',
		keystone_auth_host => $controller_virtual_ip,
		keystone_password  => $::keystone_user_password,
		rabbit_userid      => $::rabbit_user,
		rabbit_password    => $::rabbit_password,
		rabbit_host        => $::rabbit_host,
		rabbit_hosts       => $::rabbit_hosts,
		db_password        => $::cinder_db_password,
		db_dbname          => $::cinder_db_dbname,
		db_user            => $::cinder_db_user,
		db_type            => $::db_type,
		db_host            => $controller_virtual_ip,
	}	


	class {'deployment::heat_config':
		ipaddress => $ipaddress,
		}
}
