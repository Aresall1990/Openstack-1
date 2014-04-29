class deployment::swift_storage_config($ipaddress){

  class {'openstack::swift::storage-node'
     swift_zone => $::swift_zone,
     $ring_server => $::swift_ring_server
    }
  

  } # End of Storage node