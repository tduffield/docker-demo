#!/bin/bash
#mkdir -p ~/mongotest/repo
#mkdir -p ~/mongotest/repo/.chef
#cp knife.rb ~/mongotest/repo/.chef
#rm -rf ~/mongotest/repo/cookbooks
#berks vendor ~/mongotest/repo/cookbooks
#chef-client -z recipes/vagrant.rb recipes/mongo_cluster.rb
#berks install
#berks upload --force
#sudo chef-client -c ~/.chef/knife.rb recipes/vagrant.rb recipes/mongo_cluster.rb
#chef-client -z recipes/vagrant.rb recipes/mongo_cluster.rb
#chef-client -z recipes/mongo_host.rb
bundle exec berks install
bundle exec berks upload --force
bundle exec chef-client -o docker-demo::ec2,docker-demo::provisioner
