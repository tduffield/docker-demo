require 'chef_metal_fog'

ec2testdir = "#{ENV['HOME']}/ec2creds"

directory ec2testdir

with_fog_ec2_provisioner :ssh_username => 'ec2-user', :use_private_ip_for_ssh => true

with_provisioner_options 'bootstrap_options' => {
    'image_id' => 'ami-2f726546',
    'flavor_id' => 'm3.large',
    'block_device_mapping' => [{'DeviceName' => '/dev/sda1', 'Ebs.VolumeSize' => 30}]
  }

fog_key_pair "dockerdemo_ssh_key" do
  private_key_path "#{ec2testdir}/dockerdemo_ssh_key"
  public_key_path "#{ec2testdir}/dockerdemo_ssh_key.pub"
end
