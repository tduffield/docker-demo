include_recipe_now 'build-essential'

include_recipe 'openssh'
include_recipe 'docker-demo::supervisor'
include_recipe 'mongodb::install'
include_recipe 'mongodb::mongo_gem'
