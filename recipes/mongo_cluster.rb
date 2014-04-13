with_provisioner_options :use_private_ip_for_ssh => true

1.upto(1) do |i|
  machine "cluster#{i}" do
    recipe 'docker'
    recipe 'docker-demo::install_metal'
    recipe 'docker-demo::image_factory'
    recipe 'docker-demo::mongo_host'
    attribute %w(demo cheat), false # false = build images, true = download them
  end
end
