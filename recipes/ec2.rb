require 'chef_metal/fog'

ec2testdir = "#{ENV['HOME']}/ec2creds"

directory ec2testdir

with_fog_ec2_provisioner

fog_key_pair 'me2' do
  private_key_path "#{ec2testdir}/me2"
  public_key_path "#{ec2testdir}/me2.pub"
end
