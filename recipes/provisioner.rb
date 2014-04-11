machine 'provisioner' do
  recipe 'apt'
  recipe 'build-essential'
  recipe 'git'
end

machine 'provisioner' do
  recipe 'docker'
  recipe 'docker-demo::install_metal'
  recipe 'docker-demo::ec2'
  recipe 'docker-demo::mongo_cluster'
end
