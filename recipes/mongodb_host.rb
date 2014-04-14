include_recipe 'docker-demo::install_chef_metal'

require 'chef_metal_docker'
with_provisioner ChefMetalDocker::DockerProvisioner.new

include_recipe 'docker'

docker_image 'chef/mongodb_image' do
  retries 2
  action :pull_if_missing
end

num_dbservers = 2

1.upto(num_dbservers) do |i|

  machine "mongodb#{i}" do
    provisioner_options 'base_image' => 'chef/mongodb_image',
      'create_container' => {
        'command' => 'supervisord -n',
        'container_configuration' => {
          'ExposedPorts' => {
            "22/tcp" => {},
            "27017/tcp" => {}
          },
          'Tty' => true
        },
        'host_configuration' => {
          'PortBindings' => {
            "22/tcp" => [],
            "27017/tcp" => []
          }
        },
        'ssh_options' => {
          :username => 'docker',
          :password => 'docker',
          :auth_methods => [ 'password' ]
        }
      }

    recipe 'mongodb::replicaset'

    attribute %w(mongodb cluster_name), "docker"
    attribute %w(mongodb config replSet), "docker"
  end
end
