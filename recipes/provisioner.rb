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

  recipe 'docker-demo::install_metal'
  recipe 'docker-demo::ec2'
  recipe 'docker-demo::mongo_cluster'
  converge true
end
