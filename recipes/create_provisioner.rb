require 'chef_metal'
require 'chef_metal_fog'

ec2testdir = "#{ENV['HOME']}/ec2creds"
directory ec2testdir

with_fog_ec2_provisioner :ssh_username => 'ec2-user'
fog_key_pair "dockerdemo_ssh_key" do
  private_key_path "#{ec2testdir}/dockerdemo_ssh_key"
  public_key_path "#{ec2testdir}/dockerdemo_ssh_key.pub"
end

with_provisioner_options 'bootstrap_options' => {
    'image_id' => 'ami-2f726546',
    'flavor_id' => 'c1.xlarge'
  }

with_chef_server "https://api.opscode.com/organizations/tomduffield-personal", {
  :client_name => Chef::Config[:node_name],
  :signing_key_filename => Chef::Config[:client_key]
}

credentials = ChefMetal::AWSCredentials.new
credentials.load_default
aws_config = <<EOM
[default]
aws_access_key_id=#{credentials['default'][:access_key_id]}
aws_secret_access_key=#{credentials['default'][:secret_access_key]}
region=#{credentials['default'][:region]}
EOM

machine 'provisioner' do
  file '/root/.aws/config', :content => aws_config
  file '/root/ec2creds/dockerdemo_ssh_key', "#{ENV['HOME']}/ec2creds/dockerdemo_ssh_key"

  recipe 'docker-demo::provisioner'
end
