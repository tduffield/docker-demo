#node.default['build-essential']['compile_time'] = true

include_recipe_now 'build-essential'

chef_gem 'chef-metal'
chef_gem 'chef-metal-docker'
