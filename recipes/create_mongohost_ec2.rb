
#
# Launch the MongoDB Cluster Host
#
require 'chef_metal'
require 'chef_metal_fog'

ec2testdir = "#{ENV['HOME']}/ec2creds"
directory ec2testdir

with_chef_server "https://api.opscode.com/organizations/tomduffield-personal", {
  :client_name => Chef::Config[:node_name],
  :signing_key_filename => Chef::Config[:client_key]
}

with_fog_ec2_provisioner :ssh_username => 'ec2-user'
fog_key_pair "dockerdemo_ssh_key" do
  private_key_path "#{ec2testdir}/dockerdemo_ssh_key"
  public_key_path "#{ec2testdir}/dockerdemo_ssh_key.pub"
end

with_provisioner_options 'bootstrap_options' => {
    'image_id' => 'ami-2f726546',
    'flavor_id' => 'c1.xlarge',
    'block_device_mapping' => [{'DeviceName' => '/dev/sda1', 'Ebs.VolumeSize' => 30}]
  }

machine "mongodb_host" do
  recipe 'docker-demo::install_chef_metal'
end
