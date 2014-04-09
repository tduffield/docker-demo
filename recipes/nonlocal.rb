chef_gem 'cheffish'

chef_gem 'chef-metal' do
  source '/mnt/host_src/chef-metal/pkg/chef-metal-0.8.gem'
end

chef_gem 'chef-metal-docker' do
  source '/mnt/host_src/chef-metal-docker/pkg/chef-metal-docker-0.1.gem'
end

docker_image "ubuntu" do
  tag 'latest'
end
