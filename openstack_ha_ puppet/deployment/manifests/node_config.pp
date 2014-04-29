class deployment::node_config{

	$content = template('deployment/interface_config.erb')


	file{'interface_config':
		path => '/etc/network/interfaces',
		ensure => file,
		content => $content,
	}

	host{
		'imchdt022': ip => $::master_ip;	
		'control01': ip => $::control01;
		'control02': ip => $::control02;
		'compute01': ip => $::compute01;
		'control03': ip => $::control03;
	}
}

