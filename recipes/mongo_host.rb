require 'chef_metal_docker'
with_provisioner ChefMetalDocker::DockerProvisioner.new

base_port = 27020

1.upto(2) do |i|
  port = base_port + i

  machine "mongodb#{i}" do
    provisioner_options 'base_image' => 'ubuntu:latest',
      'command' => 'chef-client -o mongodb::replicaset',
      'container_options' => {
        :port => "#{port}:#{port}",
        :env => [
          'CONTAINER_NAME' => "mongodb#{i}",
          'CHEF_SERVER_URL' => 'https://api.opscode.com/organizations/tomduffield-personal',
          'VALIDATION_CLIENT_NAME' => 'tomduffield-personal-validator'
        ]
      }
    recipe 'mongodb::replicaset'
    attribute %w(mongodb config host), node['fqdn']
    attribute %w(mongodb config port), port
  end
end

