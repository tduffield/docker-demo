with_provisioner_options({})

ChefMetal.enclosing_provisioner.compute_options[:ssh_username] = 'ubuntu'

machine 'provisioner' do
  recipe 'apt'
  recipe 'build-essential'
end

credentials = ChefMetal::AWSCredentials.new
credentials.load_default
aws_config = <<EOM
[default]
aws_access_key_id=#{credentials['jkeiser'][:access_key_id]}
aws_secret_access_key=#{credentials['jkeiser'][:secret_access_key]}
region=#{credentials['jkeiser'][:region]}
EOM

machine 'provisioner' do
  file '/home/ubuntu/.aws/config', :content => aws_config

  recipe 'docker-demo::install_metal'
  recipe 'docker-demo::ec2'
  recipe 'docker-demo::mongo_cluster'
end
