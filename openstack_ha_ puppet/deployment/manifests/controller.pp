class deployment::controller (
	$public_address,
	$internal_address = false,
	$admin_address = false,
	$vncproxy_host = false,
	$ovs_local_ip = false,
	$enabled = true,
	$wsrep_user = $::wsrep_user,
	$wsrep_password = $::wsrep_password,
	$db_type = $::db_type,
	$wsrep_sst_method = $::wsrep_sst_method,
	$master_ip
) {



  if $ovs_local_ip {
    $ovs_local_ip_real = $ovs_local_ip
  } else {
    $ovs_local_ip_real = $internal_address
  }

  if $internal_address {
    $internal_address_real = $internal_address
  } else {
    $internal_address_real = $public_address
  }
  if $admin_address {
    $admin_address_real = $admin_address
  } else {
    $admin_address_real = $internal_address_real
  }
  if $vncproxy_host {
    $vncproxy_host_real = $vncproxy_host
  } else {
    $vncproxy_host_real = $public_address
  }


Class['openstack::db::mysql'] -> Class['deployment::keystone_config']

  ####### DATABASE SETUP ######
  # set up mysql server
	if ($db_type == 'mysql') {
		class { 'openstack::db::mysql':
			ipaddress => $ipaddress,
			master_ip => $master_ip,
			mysql_root_password => $::mysql_root_password,
			#mysql_bind_address => $::mysql_bind_address,
			keystone_db_user => $::keystone_db_user,
			keystone_db_password => $::keystone_db_pass,
			keystone_db_dbname => $::keystone_db_dbname,
			glance_db_user => $::glance_db_user,
			glance_db_password => $::glance_db_password,
			glance_db_dbname => $::glance_db_dbname,
			nova_db_user => $::nova_db_user,
			nova_db_password => $::nova_db_password,
			nova_db_dbname => $::nova_db_dbname,
			cinder => $::cinder,
			cinder_db_user => $::cinder_db_user,
			cinder_db_password => $::cinder_db_password,
			cinder_db_dbname => $::cinder_db_dbname,
			neutron => $::neutron,
			neutron_db_user => $::neutron_db_user,
			neutron_db_password => $::neutron_db_password,
			neutron_db_dbname => $::neutron_db_name,
			allowed_hosts => $::allowed_hosts,
			wsrep_user => $wsrep_user,
			wsrep_password => $wsrep_password,

			#Heat
			heat => $::heat,
			heat_db_user => $::heat_db_user,
			heat_db_password => $::heat_db_password,
			heat_db_dbname => $::heat_db_name,
		}
	  } else {
		fail("Unsupported db : ${db_type}")
	}

	#include rabbitmq-config
	#Class['deployment::galera'] -> Class['rabbitmq::server']

	class {'deployment::keystone_config':
		ipaddress => $public_address,
	}
}
