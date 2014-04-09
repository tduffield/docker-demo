#!/bin/bash
#mkdir -p ~/mongotest/repo
#rm -rf ~/mongotest/repo/cookbooks
#berks vendor ~/mongotest/repo/cookbooks
#chef-client -z recipes/vagrant.rb recipes/mongo_cluster.rb
berks install 
berks upload --force
#sudo chef-client -c ~/.chef/knife.rb recipes/vagrant.rb recipes/mongo_cluster.rb
#chef-client -z recipes/vagrant.rb recipes/mongo_cluster.rb
chef-client -z recipes/mongo_host.rb
#sudo chef-client -c ~/.chef/knife.rb -o recipe[docker-demo::mongo_host]
