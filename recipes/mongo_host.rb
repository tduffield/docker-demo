require 'cheffish'
require 'chef/config'

with_chef_server "https://api.opscode.com/organizations/tomduffield-personal", {
  :client_name => Chef::Config[:node_name],
  :signing_key_filename => Chef::Config[:client_key]
}

require 'chef_metal_docker'
with_provisioner ChefMetalDocker::DockerProvisioner.new

#docker_image 'ubuntu' do
#  tag '12.04'
#end

base_port = 27020

machine 'base' do
  provisioner_options 'base_image' => 'ubuntu:12.04',
    'command' => false
  run_list %w(recipe[apt] recipe[build-essential] recipe[openssh] recipe[supervisor])
end

machine "mongodb" do
  provisioner_options 'base_image' => 'base_image:latest',
  'command' => false
  run_list %w(recipe[docker-demo::supervisor] recipe[mongodb::install])
end

1.upto(4) do |i|
  port = base_port + i

  machine "mongodb#{i}" do
    provisioner_options 'base_image' => 'mongodb_image:latest',
    'command' => 'supervisord -n',
    'container_configuration' => {
      'ExposedPorts' => {
        "#{port}/tcp" => {},
        "22/tcp" => {}
      },
      'Tty' => true
    },
    'host_configuration' => {
      'PortBindings' => {
        "#{port}/tcp" => [{ "HostPort" => "#{port}" }],
        "22/tcp" => [{"HostIp" => "127.0.0.1", "HostPort" => "#{22000 + i}"}]
      }
    }
    run_list %w(recipe[mongodb::replicaset])
    attribute %w(mongodb cluster_name), "docker"
    attribute %w(mongodb config replSet), "docker"
    attribute %w(mongodb config port), port
    converge true
  end
end
