class deployment::galera(
	$controller_mgt_ip,
	$wsrep_user,
	$wsrep_password,
	$enabled,
	$wsrep_sst_method,
	$wsrep_package_name = $::wsrep_package_name,
	$galera_package_name = $::galera_package_name,
	$master_ip
){


	class { 'galera::server':
	    config_hash => {
	      'root_password'  => $::mysql_root_password,
	      'bind_address'   => $controller_mgt_ip,
	    },
	    cluster_name       => "controller_cluster",
	    master_ip          => $master_ip,
	    wsrep_bind_address => $controller_mgt_ip,
	    wsrep_sst_username => $wsrep_user,
	    wsrep_sst_password => $wsrep_password,
	    wsrep_sst_method   => $wsrep_sst_method,
	    enabled            => $enabled,
	  }

	class {'galera::monitor':
	  monitor_username => $::galera_monitor_username,
	  monitor_password => $::galera_monitor_password,
	  monitor_hostname => $controller_mgt_ip,
	  enabled          => $enabled,
	}
}

