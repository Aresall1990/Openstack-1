class deployment::horizon_config($ipaddress){

	$controller_virtual_ip = $::controller_virtual_ip

	class { 'openstack::horizon':
	      secret_key          => $::secret_key,
	      keystone_host       => $controller_virtual_ip,
	      memcached_listen_ip => $ipaddress,
	      cache_server_ip     => $ipaddress,
	      cache_server_port   => $cache_server_port,
	      horizon_app_links   => $horizon_app_links,
	      allowed_hosts       => $::allowed_hosts,
	      keystone_default_role=> '_member_'
	    }
}

