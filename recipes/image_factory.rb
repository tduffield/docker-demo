require 'chef_metal_docker'
with_provisioner ChefMetalDocker::DockerProvisioner.new

docker_image 'ubuntu' do
  tag 'latest'
end

# Build a base image with apt, chef, openssh and supervisord
# We should upload this to the registry (under tduffield/base_image) prior to
# the demo. Then before we go on stage we should retag it from tduffield/base_image
# to base_image.
machine 'base' do
  provisioner_options 'base_image' => 'ubuntu:latest', 'command' => false
  recipe 'apt'
  recipe 'build-essential'
  recipe 'openssh'
  recipe 'supervisor'
end

# Build a mongodb base image with our supervisor and a mongodb replicaset
# We should follow a similar pattern as the base image above. 
machine 'mongodb_base' do
  provisioner_options 'base_image' => 'base_image', 'command' => false
  recipe 'docker-demo::supervisor'
  recipe 'mongodb::install'
  attribute %w(mongodb cluster_name), "docker"
  attribute %w(mongodb config replSet), "docker"
end
