include_recipe 'docker-demo::install_chef_metal'

#
# Create the MongoDB base Docker container
#
require 'chef_metal_docker'
with_provisioner ChefMetalDocker::DockerProvisioner.new

include_recipe 'docker'

docker_registry 'https://index.docker.io' do
  username 'chef'
  password '#########'
  #action :login
  action :nothing
end

docker_image 'ubuntu' do
  retries 2
  tag 'latest'
  action :pull_if_missing
end
  
machine 'mongodb' do
  provisioner_options 'base_image' => 'ubuntu:latest', 'command' => false
  recipe 'build-essential'
  recipe 'openssh'
  recipe 'docker-demo::supervisor'
  recipe 'mongodb::install'
  #notifies :push, 'docker_image[mongodb_image]', :immediately
end

docker_image 'mongodb_image' do
  repository 'chef'
  action :nothing
end

#
# Launch the MongoDB Cluster Host
#
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
    'flavor_id' => 'c1.xlarge',
    'block_device_mapping' => [{'DeviceName' => '/dev/sda1', 'Ebs.VolumeSize' => 30}]
  }

machine "mongodb_host" do
  recipe 'docker-demo::mongodb_host'
end
