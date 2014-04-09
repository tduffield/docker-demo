require 'cheffish'
require 'chef/config'

with_chef_server "https://api.opscode.com/organizations/tomduffield-personal", {
  :client_name => Chef::Config[:node_name],
  :signing_key_filename => Chef::Config[:client_key]
}

require 'chef_metal_docker'
with_provisioner ChefMetalDocker::DockerProvisioner.new

base_port = 27020

#machine "mongodb" do
#  provisioner_options 'base_image' => 'ubuntu:latest',
#  'command' => false,
#  'container_options' => {
#    'ExposedPorts' => {
#      "#{port}/tcp" => {}
#    },
#    'host_options' => {
#      'PortBindings' => {
#        "#{port}/tcp" => [{ "HostPort" => port }]
#      }
#    }
#  }
#  recipe 'docker-demo::mongodb'
#  recipe 'docker-demo::supervisor'
#  recipe 'mongodb::replicaset'
#  attribute %w(mongodb install_method), "10gen"
#  complete true
#end

1.upto(2) do |i|
  port = base_port + i

  machine "mongodb#{i}" do
    #provisioner_options 'base_image' => 'mongodb_image:latest',
    provisioner_options 'base_image' => 'ubuntu:latest',
    #'command' => 'mongod -f /etc/mongodb.conf',
    'command' => 'supervisord -n',
    'container_options' => {
      'ExposedPorts' => {
        "#{port}/tcp" => {}
      },
      'host_options' => {
        'PortBindings' => {
          "#{port}/tcp" => [{ "HostPort" => port }]
        }
      }
    }
    recipe 'docker-demo::mongodb'
    recipe 'openssh'
    recipe 'docker-demo::supervisor'
    recipe 'mongodb::replicaset'
    attribute %w(mongodb install_method), "10gen"
    attribute %w(mongodb cluster_name), "docker"
    #attribute %w(mongodb server host), node['ipaddress']
    attribute %w(mongodb config replSet), "docker"
    attribute %w(mongodb server host), "172.17.42.1"
    attribute %w(mongodb config port), port
    complete true
  end
end
