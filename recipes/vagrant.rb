require 'cheffish'
require 'chef_metal_vagrant'

# Set up a vagrant cluster (place for vms) in ~/machinetest
vagrant_cluster "#{ENV['HOME']}/mongotest"
directory "#{ENV['HOME']}/mongotest/repo"

# Connect to my Chef Server
with_chef_server "https://api.opscode.com/organizations/tomduffield-personal", {
  :client_name => Chef::Config[:node_name],
  :signing_key_filename => Chef::Config[:client_key]
}
#with_chef_local_server :chef_repo_path => "#{ENV['HOME']}/mongotest/repo"

vagrant_box 'opscode-ubuntu-12.04' do
  url 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box'
  provisioner_options 'vagrant_config' => <<EOM
    config.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 4
    end
EOM
end
