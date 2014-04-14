include_recipe 'docker-demo::install_chef_metal'

#
# Create the MongoDB base Docker container
#
require 'chef_metal_docker'
with_provisioner ChefMetalDocker::DockerProvisioner.new

include_recipe 'docker'

docker_image 'ubuntu' do
  retries 2
  tag 'latest'
  action :pull_if_missing
end
  
machine 'mongodb' do
  provisioner_options 'base_image' => 'ubuntu:latest', 'command' => false
  recipe 'docker-demo::install_mongodb'
end

