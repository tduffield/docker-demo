require 'chef_metal_fog'

ec2testdir = "#{ENV['HOME']}/ec2creds"

directory ec2testdir

with_fog_ec2_provisioner  :ssh_username => 'ec2-user'


with_provisioner_options 'bootstrap_options' => {
    'image_id' => 'ami-6b021d02', #EBS-backed
    'flavor_id' => 'm3.large',
    #'block_device_mapping' => [{ :DeviceName => '/dev/sda1', 'Ebs.VolumeSize' => 30, 'Ebs.VolumeType' => 'io1'}]
  }

with_chef_server "https://ec2-54-224-52-189.compute-1.amazonaws.com/organizations/chef",  {
  :client_name => Chef::Config[:node_name],
  :signing_key_filename => Chef::Config[:client_key]
}

fog_key_pair "dockerdemo_#{ENV['USER']}" do
  private_key_path "#{ec2testdir}/dockerdemo_#{ENV['USER']}"
  public_key_path "#{ec2testdir}/dockerdemo_#{ENV['USER']}.pub"
end

machine 'dockerdemo_template' do
  recipe 'docker-demo::install_metal'
  recipe 'docker'
end

