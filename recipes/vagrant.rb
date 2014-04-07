require 'cheffish'
require 'chef_metal_vagrant'

# Set up a vagrant cluster (place for vms) in ~/machinetest
vagrant_cluster "#{ENV['HOME']}/mongotest"


directory "#{ENV['HOME']}/mongotest/repo"

with_chef_local_server :chef_repo_path => "#{ENV['HOME']}/mongotest/repo"

vagrant_box 'opscode-ubuntu-12.04' do
  provisioner_options({
    'vagrant_config' => 'config.vm.synced_folder "/Users/tomduffield/OpenSource/chef-metal-docker/", "/mnt/host_src"'
  })
end


