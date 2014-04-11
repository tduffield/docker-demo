require 'chef_metal_docker'
with_provisioner ChefMetalDocker::DockerProvisioner.new

docker_image 'ubuntu' do
  tag 'latest'
  action :pull
end

if node['demo']['cheat'] 
  docker_image 'chef/docker_demo_base' do
    tag 'base_image'
    action [:pull_if_missing, :tag]
  end

  docker_image 'chef/docker_demo_mongodb_base' do
    tag 'mongodb_base_image'
    action [:pull_if_missing, :tag]
  end
else
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
    provisioner_options 'base_image' => 'mongodb_base', 'command' => false
    recipe 'docker-demo::supervisor'
    recipe 'mongodb::install'
  end
end
