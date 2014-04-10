machine 'provisioner' do
  recipe 'build-essential'
  recipe 'docker'
  recipe 'docker-demo::install_metal'
  recipe 'docker-demo::mongo_cluster'
end
