1.upto(1) do |i|
  machine "cluster#{i}" do
    recipe 'docker'
    recipe 'docker-demo::mongo_host'
  end
end
