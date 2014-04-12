require 'chef_metal_fog'

ec2testdir = "#{ENV['HOME']}/ec2creds"

directory ec2testdir

with_fog_ec2_provisioner  :ssh_username => 'ec2-user'


with_provisioner_options 'bootstrap_options' => {
    'image_id' => 'ami-6b021d02', #EBS-backed
    'flavor_id' => 'm3.large'
  }

fog_key_pair "dockerdemo_#{ENV['USER']}" do
  private_key_path "#{ec2testdir}/dockerdemo_#{ENV['USER']}"
  public_key_path "#{ec2testdir}/dockerdemo_#{ENV['USER']}.pub"
end
