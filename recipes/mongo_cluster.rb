1.upto(1) do |i|
  machine "dockerdemo_cluster#{i}" do
    recipe 'apt'
    recipe 'build-essential'
    recipe 'git'
  end

  machine "dockerdemo_cluster#{i}" do
    recipe 'docker'
    recipe 'docker-demo::install_metal'
    recipe 'docker-demo::image_factory'
    recipe 'docker-demo::mongo_host'
  end
end
