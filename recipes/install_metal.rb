chef_gem 'chef-metal'
chef_gem 'chef-metal-fog'

git "#{Chef::Config[:file_cache_path]}/chef-metal-docker" do
  repository "https://github.com/opscode/chef-metal-docker"
  action :nothing
end.run_action(:sync)

chef_gem 'chef-metal-docker' do
  source "#{Chef::Config[:file_cache_path]}/chef-metal-docker/pkg/chef-metal-docker-0.1.gem"
  subscribes :install, "git[#{Chef::Config[:file_cache_path]}/chef-metal-docker]", :immediately
end

