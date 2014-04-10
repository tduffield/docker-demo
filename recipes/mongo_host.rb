require 'chef_metal_docker'
with_provisioner ChefMetalDocker::DockerProvisioner.new

base_port = 27020

1.upto(2) do |i|
  port = base_port + i

  machine "mongodb#{i}" do
    provisioner_options 'base_image' => 'mongodb_base_image',
      #
      # Run the supervisor permanently after converge
      #
      'command' => 'supervisord -n',
      #
      # Expose the Mongo and SSH ports to the host
      #
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
