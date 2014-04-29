# file to set up /etc/network/interface on different nodes



class deployment::puppet_client_setup{

	class network_service{
		notify{"networking":,}
	}

	node base{
		include deployment::node_config
		include $::network_service
	}


	node 'slb01' inherits base{
		class {"deployment::load_balancer" :
		     controller_virtual_ip   => $::controller_virtual_ip,
		     swift_proxy_virtual_ip  => $::swift_proxy_virtual_ip,
		     keepalived_interface    => $::keepalived_interface,
			 controller_names        => $::controller_names,
			 controller_ipaddresses  =>  $::controller_ipaddresses,
		     swift_proxy_names       => $::swift_proxy_names,
		     swift_proxy_ipaddresses =>  $::swift_proxy_ipaddresses,
			 controller_state => 'MASTER',
			 swift_proxy_state => 'BACKUP',
		   }
	 }

	node 'slb02' inherits base{
		class {"deployment::load_balancer" :
		     controller_virtual_ip   => $::controller_virtual_ip,
		     swift_proxy_virtual_ip  => $::swift_proxy_virtual_ip,
		     keepalived_interface    => $::keepalived_interface,
			 controller_names        => $::controller_names,
			 controller_ipaddresses  =>  $::controller_ipaddresses,
		     swift_proxy_names       => $::swift_proxy_names,
		     swift_proxy_ipaddresses =>  $::swift_proxy_ipaddresses,
			 controller_state => 'BACKUP',
			 swift_proxy_state => 'MASTER',
	
		   }
	 }
	
	class controller1{
		node 'control01' inherits base{
			class { 'deployment::controller':
				master_ip => "", # false for the first control node, as no cluster is created yet
				public_address => $ipaddress,
			}
		}
	}

	class controller_remaining{

		node 'control02' inherits base{
			class { 'deployment::controller':
				# false for the first control node, as no cluster is created yet
				master_ip => $::control01, 
				public_address => $ipaddress,
			}
		}
		node 'control03' inherits base{
			class { 'deployment::controller':
				# false for the first control node, as no cluster is created yet
				master_ip => $::control02, 
				public_address => $ipaddress,
			}
		}	
	}


	class compute_nodes{
		node 'compute01' inherits base{
			class{'deployment::compute_config':
					ipaddress => $ipaddress,
				}
		}
		#node /compute02/ inherits base{}
	}
	


	node 'swiftstorage01' inherits base{
		class {'deployment::swift_storage_config':
				ipaddress => $ipaddress,
			}
	}
	#node 'swift02/ inherits base{}
	
	node 'swiftproxy01' inherits base{
		class {'deployment::swift_proxy_config':
				ipaddress => $ipaddress,
			}
	}
	#node /swiftproxy02/ inherits base{}


#	service { 'networking':
#	    ensure => 'running',
#        enable => true,
#        hasrestart => true,
#		restart => "/etc/init.d/networking restart"
#	}

	exec {'networking':
		#path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ], #mentioned in site.pp
		command => '/etc/init.d/networking restart',
	}	

	exec {'install-ntp':
		#path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
		command => 'apt-get install -y ntp',
		require => Exec["networking"],
	}	

	exec {'ntp':
		#path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ], #mentioned in site.pp
		command => 'puppet module install puppetlabs/ntp',
		require => Exec['install-ntp']
	}

#	class { '::ntp':
#	  servers => [ 'ntp1.corp.com', 'ntp2.corp.com' ],
#	}

}# end of puppet_client_setup class

