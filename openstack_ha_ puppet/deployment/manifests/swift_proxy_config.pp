class deployment::swift_proxy_config($ipaddress){

 class { 'openstack::swift::proxy':
  $swift_user_password              = $::password,
  $swift_hash_suffix                = $::password,
  $controller_node_address          = $::controller_virtual_ip,
  $keystone_host                    = $::controller_virtual_ip,
  $swift_memcache_servers           = $::memcached_servers,
  $memcached_listen_ip              = $ipaddress
  }


}# End of swift config
