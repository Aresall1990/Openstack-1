class deployment::galera_server(
	$controller_mgt_ip,
	$wsrep_user,
	$wsrep_password,
	$wsrep_sst_method,
	$manage_service = true,
	$enabled,
	$wsrep_package_name = $::wsrep_package_name,
	$galera_package_name = $::galera_package_name,
	$wsrep_cluster_name = $::wsrep_cluster_name,
)
{

	exec{'mysql-galera':
		command => "apt-get install -y ${wsrep_package_name} ${galera_package_name} python-mysqldb",
	}

	exec{"exec-sed":
		command => "sed -i 's/127.0.0.1/${controller_mgt_ip}/g' /etc/mysql/my.cnf",
		require => Exec['mysql-galera']
	}

#	exec{"mysql-restart":
#		command => "service mysql start",
#		require => [Exec['exec-sed'], Exec['mysql-galera']]
#	}

	file { 'wsrep_cnf' :
		path => '/etc/mysql/conf.d/wsrep.cnf',
		ensure  => file,
		mode    => '0644',
		owner   => 'root',
		content => template('galera/wsrep.cnf.erb'),
		notify  => Service["mysqld"]
	  }

	if $enabled {
		$service_ensure = 'running'
	  } else {
		$service_ensure = 'stopped'
	  }

	  if $manage_service {
		Service["mysqld"] -> Exec<| title == 'set_mysql_rootpw' |>
		service { "mysqld":
		  ensure   => $service_ensure,
		  name     => 'mysql',
		  enable   => $enabled,
		  require  => [Exec['mysql-galera']]
		}
	  }

}
