1.upto(1) do |i|
  machine "cluster#{i}" do
    recipe 'build-essential'
    recipe 'docker'
    recipe 'docker-demo::install_metal'
    recipe 'docker-demo::mongo_host'
  end
end
