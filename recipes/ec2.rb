require 'chef_metal_fog'

ec2testdir = "#{ENV['HOME']}/ec2creds"

directory ec2testdir

with_fog_ec2_provisioner

with_provisioner_options :image_id => 'ami-0d273b64', :flavor_id => 'm3.large'

with_chef_server "https://ec2-54-224-52-189.compute-1.amazonaws.com/organizations/chef",  {
  :client_name => Chef::Config[:node_name],
  :signing_key_filename => Chef::Config[:client_key]
}

fog_key_pair "dockerdemo_#{ENV['USER']}" do
  private_key_path "#{ec2testdir}/dockerdemo_#{ENV['USER']}"
  public_key_path "#{ec2testdir}/dockerdemo_#{ENV['USER']}.pub"
end
