#!/bin/bash

if [ -z $1 ]; then 
  berks install
  berks upload --force
fi

#chef-client -o docker-demo::ec2,docker-demo::provisioner
#chef-client -c ~/.chef/knife.rb -o docker-demo::ec2,docker-demo::provisioner
chef-client -c ~/.chef/knife.rb -o docker-demo::ec2,docker-demo::mongo_cluster
#chef-client -c ~/.chef/knife.rb -o docker-demo::ec2,docker-demo::mongo_cluster
#chef-client -c ~/.chef/knife.rb -o docker-demo
