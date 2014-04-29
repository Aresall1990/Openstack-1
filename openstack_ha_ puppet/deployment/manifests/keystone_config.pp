class deployment::keystone_config($ipaddress){

 class { 'openstack::keystone':
   db_host               => $::controller_virtual_ip,
   db_user               => $::keystone_db_user,
   db_password           => $::keystone_db_pass,
   db_name               => $::keystone_db_dbname,
   admin_password        => $::keystone_user_password,
   admin_token           => 'keystone_admin_token',
   admin_email           => 'root@localhost',
   idle_timeout          => $::sql_idle_timeout,
   
   glance_user_password  => $::glance_user_password,
   nova_user_password    => $::nova_user_password,
   cinder_user_password  => $::cinder_user_password,
   neutron_user_password => $::neutron_user_password,
   public_address        => $::controller_virtual_ip,
   bind_host             => $ipaddress,
   admin_address         => $::controller_virtual_ip,
   internal_address      => $::controller_virtual_ip,
   token_driver          => $::keystone_token_driver,
   token_provider        => $::keystone_token_provider,
   enabled               => true,

  #swift
  #swift                  => $::swift_enabled, 
  swift                  => false, 
  swift_user_password    => $::swift_user_password,

  # heat
  heat                   => $::heat,
  heat_user_password     => $::heat_user_password,

  # heat-cfn (cloudformation api)
  heat_cfn                    => $::heat_cfn,
  heat_cfn_user_password      => $::heat_cfn_user_password,

 }


Class['openstack::db::mysql'] -> Class['deployment::glance_config']
	class{'deployment::glance_config':
			ipaddress => $ipaddress,
}

}# End of keystone config
