$cisco_mirror_list = "/etc/apt/sources.list.d/cisco-openstack-mirror-havana.list"

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }


# /etc/network/interface configuration
$master_ip = '192.168.6.28'
$broadcast = '172.17.2.255'
$gateway = '172.17.2.254'
$dns_nameservers = '172.17.2.254'


# nodenames

#loadbalancer node name and ip
$loadbalancer_01 = 'slb01'
$loadbalancer_ip_01 = '172.17.2.74'

#virtual_ip = 172.17.2.60
$slb02 = '172.17.2.75'	
$control01 = '172.17.2.84'
#$control02 = '172.17.2.80'
$control02 = '172.17.2.85'
$control03 = '172.17.2.86'
#compute01 = '172.17.2.54'
#compute02 = '172.17.2.54'



# configuration for node balanancer 1
$controller_names = ['control01', 'control02', 'control03']
$controller_virtual_ip   = '172.17.2.201'
$swift_proxy_virtual_ip  = '172.17.2.200'
$keepalived_interface    = 'eth0'
$controller_ipaddresses  = [$control01, $control02, $control03,]
$swift_proxy_names       = ['swift01, swift02']
$swift_proxy_ipaddresses = ['4.4.4.4, 5.5.5.5']



#controller configuration
$db_type = 'mysql'

#controller configuration ends




#galera config
$wsrep_package_name = 'mysql-server-wsrep'
$galera_package_name = 'galera'
$wsrep_sst_method = 'rsync'
$wsrep_cluster_name = "controller_cluster"
$wsrep_user = wsrep_user
$wsrep_password = wsrep_password
#galera config ends








include deployment
include deployment::dependency
include deployment::puppet_client_setup

include deployment::puppet_client_setup::controller1
include deployment::puppet_client_setup::controller_remaining

Class['deployment::puppet_client_setup::controller1'] -> Class['deployment::puppet_client_setup::controller_remaining']



