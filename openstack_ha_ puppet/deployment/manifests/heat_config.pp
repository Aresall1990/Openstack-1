class deployment::heat_config($ipaddress){

	$controller_virtual_ip = $::controller_virtual_ip

	class { 'openstack::heat1':
		auth_host           => $controller_virtual_ip,
		# The keystone_password parameter is mandatory
		keystone_host      => $controller_virtual_ip,
		keystone_password  => $::keystone_user_password,
		admin_token        => $::keystone_admin_token,
	 	rabbit_host        => $controller_virtual_ip,
		rabbit_hosts       => $::rabbit_hosts,
		rabbit_userid      => $::rabbit_user,
		rabbit_password    => $::rabbit_password,
		db_host            => $::controller_virtual_ip,
		db_password        => $::heat_db_password,
		bind_host          => $ipaddress
	  }


	  class {'deployment::horizon_config':
	  		ipaddress => $ipaddress,
	  	}

} # End of heat config
