#-n/bin/bash

. /root/openrc

if  manila type-list | grep -q 'default_share_type'; then
    echo 'add default_share_type'
    manila type-create default_share_type True
fi

if  manila share-network-list | grep -q 'test_share_network'; then
    echo 'add test_share_network'
    net_uid=$(neutron net-list | grep -q 'internal' | cut -f2 -d' ')
    subnet_uid=$(neutron net-list | grep -q 'internal' | cut -f6 -d' ')
    manila share-network-create \
	   --name test_share_network  \
	   --neutron-net-id $net_uid  \
	   --neutron-subnet-id $subnet_uid
fi

if  openstack flavor list | grep -q 'manila-service-flavor'; then
    echo 'add manila-service-flavor'
    openstack flavor create manila-service-flavor \
      --id 100  \
      --ram 256 \
      --disk 0  \
      --vcpus 1
fi
