class openstack::heat1 (
	$auth_host          = '127.0.0.1',
	$keystone_host      = '127.0.0.1',
	$keystone_port      = '35357',
	$keystone_protocol  = 'http',
	$keystone_user      = 'heat',
	$keystone_tenant    = 'services',
	$keystone_password  = false,
	$db_user            = 'heat',
	$db_password        = 'heat_pass',
	$db_host            = '127.0.0.1',
	$db_name            = 'heat',
	$rabbit_host        = '127.0.0.1',
	$rabbit_port        = 5672,
	$rabbit_hosts       = undef,
	$rabbit_userid      = 'guest',
	$rabbit_password    = '',
	$rabbit_virtualhost = '/',
	$db_type             = 'mysql',
	$bind_host           = '0.0.0.0',
	$admin_token         = '12345'
) {


   $auth_uri = "http://${auth_host}:5000/v2.0/"
  # Configure the db string
  case $db_type {
    'mysql': {
      if $db_ssl == true {
        $sql_connection = "mysql://${db_user}:${db_password}@${db_host}/${db_name}?ssl_ca=${db_ssl_ca}"
      } else {
        $sql_connection = "mysql://${db_user}:${db_password}@${db_host}/${db_name}"
      }
    }
    default: {
      fail("db_type ${db_type} is not supported")
    }
  }

  if $keystone_host != '127.0.0.1'{
  	$keystone_ec2_uri = "http://${keystone_host}:5000/v2.0/ec2tokens"
  } else {
  	$keystone_ec2_uri = "http://127.0.0.1:5000/v2.0/ec2tokens"
  }

  # Install and config heat
	class{'heat':
		auth_uri           => $auth_uri,
		keystone_host      => $keystone_host,
		keystone_port      => $keystone_port,
		keystone_protocol  => $keystone_protocol,
		keystone_user      => $keystone_user,
		keystone_tenant    => $keystone_tenant,
		keystone_password  => $keystone_password,
		rabbit_host        => $rabbit_host,
		rabbit_port        => $rabbit_port,
		rabbit_hosts       => $rabbit_hosts,
		rabbit_userid      => $rabbit_userid,
		rabbit_password    => $rabbit_password,
		rabbit_virtualhost => $rabbit_virtualhost,
		sql_connection     => $sql_connection,
		keystone_ec2_uri   => $keystone_ec2_uri
	}


  # Install and configure heat-api
  class { 'heat::engine':
 		auth_encryption_key => 'whatever-key-you-like',
    heat_metadata_server_url      => "http://${keystone_host}:8000",
    heat_waitcondition_server_url => "http://${keystone_host}:8000/v1/waitcondition",
    heat_watch_server_url         => "http://${keystone_host}:8003",
  }

  # Install and configure heat-api
  class { 'heat::api':
    bind_host         => $bind_host,
    enabled           => true,
    auth_host         => $keystone_host,
    admin_password    => $keystone_password,
    admin_token       => $admin_token,
    auth_uri          => $auth_uri
  }

  #Install and configure heat-api-cloudwatch
  class{'heat::api_cloudwatch':
  		enabled       => true,
  		bind_host     => $bind_host
  }

  #Install and configure heat-api-cfn
  class{'heat::api_cfn':
  		enabled       => true,
  		bind_host     => $bind_host	
  }
}


