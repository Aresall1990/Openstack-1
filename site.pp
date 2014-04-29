$cisco_mirror_list = "/etc/apt/sources.list.d/cisco-openstack-mirror-havana.list"

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }


# /etc/network/interface configuration
$master_ip = '172.17.0.17'
$broadcast = '172.17.3.255'
$gateway_control01 = '172.17.3.254' # same gateway for compute01, slb01, slb02
$gateway_control02 = '192.168.2.1'
$dns_nameservers = '8.8.8.8'


# nodenames

#loadbalancer node name and ip
$loadbalancer_01 = 'slb01'
$loadbalancer_ip_01 = '172.17.2.74'

#virtual_ip = 172.17.2.60
$slb02 = '172.17.2.52'	
$control01 = '172.17.2.91'
$control02 = '172.17.2.92'
$control03 = '192.168.2.101'
#$control03 = '172.17.2.92'
$compute01 = '172.17.2.81'
#compute02 = '172.17.2.54'

$password = 'pramati123'

# configuration for node balanancer 1
$controller_names = ['control01', 'control02', 'control03']
$controller_virtual_ip   = '172.17.2.201'
$swift_proxy_virtual_ip  = '172.17.2.200'
$keepalived_interface    = 'eth0'
$controller_ipaddresses  = [$control01, $control02, $control03,]
$memcached_servers = ["${controller_virtual_ip}:11211", "${control01}:11211", "${control02}:11211", "${control03}:11211"]



#controller configuration
$db_type = 'mysql'
$sql_idle_timeout = '30'
$mysql_root_password = $password
$mysql_bind_address = $controller_virtual_ip
#$mysql_bind_address = $control01

#controller configuration ends


#galera config
$wsrep_package_name = 'mysql-server-wsrep'
$galera_package_name = 'galera'
$wsrep_sst_method = 'rsync'
$wsrep_cluster_name = "controller_cluster"
$wsrep_user = wsrep_user
$wsrep_password = wsrep_password
# for galera health check
$galera_monitor_username = "monitor_user"
$galera_monitor_password = "monitor_password"
#galera config ends

#keystone config
$keystone_db_dbname = 'keystone'
$keystone_db_pass = $password
$keystone_db_user = 'keystone_admin'
$keystone_user_password = $password
$keystone_admin_token = 'keystone_admin_token'
$keystone_token_driver = 'keystone.token.backends.sql.Token'
$keystone_token_provider = 'keystone.token.providers.uuid.Provider'
#$keystone_token_provider = 'keystone.token.providers.pki.Provider'


#glance config
$glance_db_dbname = 'glance'
$glance_db_user = 'glance'
$glance_db_password = $password
$glance_user_password = $password


#Nova config
$nova_db_user = 'nova'
$nova_db_dbname = 'nova'
$nova_db_password = $password
$nova_admin_user = 'nova'
$nova_user_password = $password

if $virtual == 'virtualbox'{
	$private_interface  = 'eth1'
	$public_interface   = 'eth2'
}else{
	$private_interface  = 'eth1'
	$public_interface   = 'eth0'
}


#rabbit config
$rabbit_userid = 'openstack_rabbit_user'
$rabbit_password = 'openstack_rabbit_password'
$rabbit_user = 'openstack_rabbit_user'
$rabbit_host = $controller_virtual_ip
$rabbit_hosts = ['control01:5672', 'control02:5672', 'control03:5672']
# path to nova, used in neutron config
$rabbit_virtual_host = '/' 


#cinder config
# to configure cinder or not
$cinder = true
$cinder_db_password = $password
$cinder_db_dbname = 'cinder'
$cinder_db_user = 'cinder'
$cinder_user_password = $password


# neutron config
$neutron = true
$neutron_db_password = $password
$neutron_db_dbname = 'neutron'
$neutron_db_user = 'neutron'
$neutron_admin_user = 'neutron'
$neutron_user_password = $password
$external_bridge_name = 'br-ex'
$bridge_interface = 'eth1'
$physical_network = 'physnet1'
$ovs_local_ip = '10.10.10.10'


# swift config
$swift_enabled = true
$swift_store_key = $password
#proxy node
$swift01_ip = '17.172.2.40'
#storage node
$swift02_ip = '17.172.2.41'
$swift_proxy_names       = ['swift01, swift02']
$swift_proxy_ipaddresses = ['4.4.4.4, 5.5.5.5']
$swift_zone_01 = '1'
$swift_zone_02 = '2'
$swift_ring_server = $swift01_ip
$swift_user_password = $password

#heat config
$heat = true
$heat_db_password = $password
$heat_db_dbname = 'heat'
$heat_db_user = 'heat'
$heat_admin_user = 'heat'
$heat_user_password = $password

$heat_cfn = true
$heat_cfn_user_password = $password


case $hostname{
	control01, compute01, slb01, slb02, control02: {$gateway= $::gateway_control01}

	swift01 :  {$gateway= $::gateway_control01}
	swift01:	{$swift_zone= $swift_zone_01}

	swift02 :  {$gateway= $::gateway_control01}
	swift02 :  {$swift_zone = $swift_zone_02}

	control03: {$gateway= $::gateway_control02}
	default : {$gateway= $::gateway_control01}
}


# Horizon Config
#A secret key for a particular Django installation
$secret_key = 'some key'
$memcached_listen_ip = '172.17.2.201'


$allowed_hosts = ['localhost', '127.0.0.1', '172.17.2.201', '172.17.2.91', '172.17.2.51', '172.17.2.52', '172.17.2.81', '192.168.2.101', '172.17.2.92']

include deployment
include deployment::dependency
include deployment::puppet_client_setup

include deployment::puppet_client_setup::controller1
include deployment::puppet_client_setup::controller_remaining
include deployment::puppet_client_setup::compute_nodes

Class['deployment::dependency'] -> Class['deployment::puppet_client_setup']
Class['deployment::dependency'] -> Class['deployment::puppet_client_setup::controller1'] -> Class['deployment::puppet_client_setup::controller_remaining']
Class['deployment::dependency'] -> Class['deployment::puppet_client_setup::controller1'] -> Class['deployment::puppet_client_setup::compute_nodes']
Class['deployment::dependency'] -> Class['deployment::puppet_client_setup::controller_remaining'] -> Class['deployment::puppet_client_setup::compute_nodes']





#glance --os-username=admin --os-password=keystone_admin --os-tenant-name=admin --os-auth-url=http://control01:35357/v2.0   image-#list

#glance --os-username=admin --os-password=keystone_admin --os-tenant-name=admin --os-auth-url=http://control01:35357/v2.0 image-#create --name cirros --is-public=true --disk-format=qcow2 --container-format=ovf < cirros-0.3.1-x86_64-disk.img
