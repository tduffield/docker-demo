#
# Cookbook Name:: docker-demo
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'docker-demo::image_factory'
include_recipe 'docker-demo::mongo_host'
