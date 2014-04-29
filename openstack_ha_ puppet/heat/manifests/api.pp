# Installs & configure the heat API service

class heat::api (
  $admin_password, 
  $enabled           = true,
  $bind_host         = '0.0.0.0',
  $bind_port         = '8004',
  $auth_host         = '127.0.0.1',
  $auth_port         = '5000',
  $auth_protocol     = 'http',
  $auth_uri          = false,
  $admin_tenant_name = 'services',
  $admin_user        = 'heat',
  $admin_token       =  '12345'

) {

  include heat
  include heat::params

  Heat_config<||> ~> Service['heat-api']

  Package['heat-api'] -> Heat_config<||>
  Package['heat-api'] -> Service['heat-api']

  package { 'heat-api':
    ensure => installed,
    name   => $::heat::params::api_package_name,
  }

  Heat_paste_api_ini<||> -> Service['heat-api']

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

	exec {'heat-dbsync':
		path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
		command => "heat-manage db_sync"
	}

  service { 'heat-api':
    ensure     => $service_ensure,
    name       => $::heat::params::api_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    require    => [Package['heat-common'],
                  Package['heat-api']],
    subscribe  => Exec['heat-dbsync'],
  }

  heat_config {
    'heat_api/bind_host'  : value => $bind_host;
    'heat_api/bind_port'  : value => $bind_port;
  }

if $auth_uri {
    heat_paste_api_ini { 'filter:authtoken/auth_uri': value => $auth_uri; }
  } else {
    heat_paste_api_ini { 'filter:authtoken/auth_uri': value => "${auth_protocol}://${auth_host}:5000/v2.0/"; }
  }

  heat_paste_api_ini {
   'filter:authtoken/service_host':      value => $auth_host;
   'filter:authtoken/service_port':      value => $auth_post;
   'filter:authtoken/service_protocol':  value => $auth_protocol;
   'filter:authtoken/auth_host':         value => $auth_host;
   'filter:authtoken/auth_port':         value => $auth_port;
   'filter:authtoken/auth_protocol':     value => $auth_protocol;
   'filter:authtoken/admin_tenant_name': value => $admin_tenant_name;
   'filter:authtoken/admin_user':        value => $admin_user;
   'filter:authtoken/admin_password':    value => $admin_password;
   'filter:authtoken/admin_token':       value => $admin_token;
  }
}
