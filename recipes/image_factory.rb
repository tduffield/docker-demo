require 'chef_metal_docker'
with_provisioner ChefMetalDocker::DockerProvisioner.new

# Build a base image with apt, chef, openssh and supervisord
machine 'base' do
  provisioner_options 'base_image' => 'ubuntu:12.04', 'command' => false
  recipe 'apt'
  recipe 'build-essential'
  recipe 'openssh'
  recipe 'supervisor'
end

# Build a mongodb base image with our supervisor and a mongodb replicaset
machine 'mongodb_base' do
  provisioner_options 'base_image' => 'base_image', 'command' => false
  recipe 'docker-demo::supervisor'
  recipe 'mongodb::replicaset'
  attribute %w(mongodb cluster_name), "docker"
  attribute %w(mongodb config replSet), "docker"
  attribute %w(mongodb server host), "172.17.42.1"
  attribute %w(mongodb config port), base_port
end
