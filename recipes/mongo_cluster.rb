1.upto(1) do |i|
  # We are splitting these machines up because of some funky behavior with 
  # include_recipe_now where it wont include apt before build-essential. I
  # tried to fix it but I was defeated.
  
  machine "cluster#{i}" do
    recipe 'apt'
    recipe 'build-essential'
    #recipe 'git'
  end

  machine "cluster#{i}" do
    recipe 'docker'
    recipe 'docker-demo::install_metal'
    recipe 'docker-demo::image_factory'
    recipe 'docker-demo::mongo_host'
    attribute %w(demo cheat), true # false = build images, true = download them
  end
end
