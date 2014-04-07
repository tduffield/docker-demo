chef_gem 'chef-metal-docker' do
  source '/mnt/host_src/pkg/chef-metal-docker-0.1.gem'
  action :install
end

require 'chef_metal_docker'
with_provisioner ChefMetalDocker::DockerProvisioner.new

docker_image "ubuntu" do
  tag 'latest'
end

base_port = 27020

1.upto(2) do |i|
  port = base_port + i

  machine "mongodb#{i}" do
    provisioner_options 'base_image' => 'ubuntu:latest',
      'container_options' => {
        :port => "#{port}:#{port}"
      }
    recipe 'mongodb::replicaset'
    attribute %w(mongodb config host), node['fqdn']
    attribute %w(mongodb config port), port
  end
end

