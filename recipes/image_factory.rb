require 'chef_metal_docker'
with_provisioner ChefMetalDocker::DockerProvisioner.new


#
# This is the cheaters section. Instead of building the base
# boxes we just download them from our docker registry.
#
if node['demo']['cheat'] 
  docker_image 'chef/docker_demo_base' do
    action :pull_if_missing
    notifies :run, "execute[rename_base]", :immediately
  end

  docker_image 'chef/docker_demo_mongodb_base' do
    action :pull_if_missing
    notifies :run, "execute[rename_mongo]", :immediately
  end

  # There isn't a great way to rename docker containers using the LWRP
  execute 'rename_base' do
    command 'docker tag chef/docker_demo_base base_image'
    action :nothing
  end

  execute 'rename_mongo' do
    command 'docker tag chef/docker_demo_mongodb_base mongodb_base_image'
    action :nothing
  end
else

  # Here is where we actually build the base containers!
  docker_image 'ubuntu' do
    tag 'latest'
    action :pull
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
  end
end
