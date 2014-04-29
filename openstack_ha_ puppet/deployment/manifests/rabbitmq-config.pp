class rabbitmq-config{


	#class {'rabbitmq::server':
	#	config_cluster => true,
	#	cluster_disk_nodes => $::controller_names,
	#	delete_guest_user => true,
	#	wipe_db_on_cookie_change => true
	#}


	#class create_cluster{}# End of create_cluster




}# End of rabitmq class


