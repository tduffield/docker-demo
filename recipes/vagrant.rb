require 'cheffish'
require 'chef_metal_vagrant'

# Set up a vagrant cluster (place for vms) in ~/machinetest
vagrant_cluster "#{ENV['HOME']}/mongotest"


directory "#{ENV['HOME']}/mongotest/repo"

#with_chef_local_server :chef_repo_path => "#{ENV['HOME']}/mongotest/repo"

vagrant_box 'opscode-ubuntu-12.04' do
  url 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box'
  provisioner_options 'vagrant_config' => <<EOM
    config.vm.synced_folder "../oc/code/opscode", "/mnt/host_src"
EOM
end
