class deployment::dependency{
        file{$::cisco_mirror_list:
        ensure => file,
        }
        notify{" file created":
        require => File[$::cisco_mirror_list],
    }

        exec { "apt-update":
        path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
            command => "apt-get update",
        }

        apt::source{"cisco":
        location=> "http://openstack-repo.cisco.com/openstack/cisco",
        repos=> "main",
        include_src=> true,
        key=> 'E8CC67053ED3B199',
        require => [File[$::cisco_mirror_list], Exec['apt-update']],
        }

        apt::source{"cisco-supplemental":
        location=> "http://openstack-repo.cisco.com/openstack/cisco_supplemental",
        release  => 'havana-proposed',
        repos=>"main",
        include_src=> true,
        key=> 'E8CC67053ED3B199',
        require => [File[$::cisco_mirror_list], Exec['apt-update']],
        }
}

