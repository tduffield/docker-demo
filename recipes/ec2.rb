require 'chef_metal_fog'

ec2testdir = "#{ENV['HOME']}/ec2creds"

directory ec2testdir

with_fog_ec2_provisioner

with_provisioner_options :image_id => 'ami-0d273b64',
  :flavor_id => 'm3.large'

fog_key_pair 'me2' do
  private_key_path "#{ec2testdir}/me2"
  public_key_path "#{ec2testdir}/me2.pub"
end
