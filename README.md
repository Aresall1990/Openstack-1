Openstack-HA puppet automation
===============================

Overview
=========
> This script is used to deploy full openstack setup. This module supports Openstack Havana release. Following are the list of components which it deploys:
* Control nodes
* Compute
* Load Balancers
* Swift Proxy
* Swift storage

The modules and other dependent components which are supported and installed are:
* nova (compute and controller) 
* glance
* keystone
* swift
* heat
* horizon
* sql
* gallera
* RabbitMQ
* neutron(GRE)


Dependecies
============

> Puppet 2.7 or greater

Requirements
============

> As per the give site.pp, three machines for control node, one compute node, two load balancers are needed for openstack setup. Ensure that control and compute nodes have two NIC and compute node is KVM enabled


> It is mandatory to keep controller hostname as in format 'control01' , 'control02' and so on
> compute node hostname as 'compute01', 'compute02' and so on
> loadbalancer hostname as 'slb01', 'slb02' and so on.

Usage
======

- Install puppet master on master node
- On your master replace /etc/puppet/manifests/site.pp with above site.pp and modify the parameters in site.pp according to your network.
- Pull the above code in your /etc/puppet/modules/
- Follow the given below steps to setup the puppet on machines which will be used as controller, compute or load balancer:
1. Login as root
2. ```#ifconfig```
3. Check for two ethernets, eth0 and eth1. If not available then do 
    ```#dhclient eth1```
4. ```# apt-get install ssh```
5. Add master ip to hosts file

    ```vim /etc/hosts```
    
    ```192.168.6.28 puppetmaster```
6. ```#apt-get install -y python-software-properties```
7. ```#add-apt-repository cloud-archive:havana```

8. ``` wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb```
9. ```apt-get update && apt-get dist-upgrade -y```
10. ```apt-get install -y puppet```
11.  ```vim /etc/puppet/puppet.conf```
```	
    pluginsync=true
	reports=true
	certname=control01 # hostname of the node
	server=puppetmaster```
12. ```# puppet agent --server puppetmaster -t  ```

    The above(step 12) command will send a certificate sign request to master. Sign that certification for each node using following command:
    ``` # puppet cert --sign --all ```

    Now again repeat step 12 on the individual nodes, it will install the correspoding modules and dependencies on the given node


    
