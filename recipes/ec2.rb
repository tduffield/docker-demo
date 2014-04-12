require 'chef_metal_fog'

ec2testdir = "#{ENV['HOME']}/ec2creds"

directory ec2testdir

with_chef_server "https://manage-chefconf-demo.opscode.com/organizations/chef", {
  :client_name => Chef::Config[:node_name],
  :signing_key_filename => Chef::Config[:client_key]
}

with_fog_ec2_provisioner :ssh_username => 'ec2-user'

with_provisioner_options 'bootstrap_options' => {
    'image_id' => 'ami-2f726546',
    'flavor_id' => 'm3.large',
    'block_device_mapping' => [{'DeviceName' => '/dev/sda1', 'Ebs.VolumeSize' => 30}]
  }

fog_key_pair "dockerdemo_#{ENV['USER']}" do
  private_key_path "#{ec2testdir}/dockerdemo_#{ENV['USER']}"
  public_key_path "#{ec2testdir}/dockerdemo_#{ENV['USER']}.pub"
end
