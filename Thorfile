# encoding: utf-8
require 'thor'

class Demo < Thor

  desc 'factory', 'Builds the base images using Chef'
  def factory 
    exec %Q(
      docker login -u #{ENV['DOCKER_USER']} -p #{ENV['DOCKER_PW']} -e #{ENV['DOCKER_EMAIL']}
      docker pull -t latest ubuntu
      chef-client -z recipes/local_base.rb
    )
  end

  desc 'commit', 'Saves the base images to Docker index'
  def commit
    exec %Q(
      docker login -u #{ENV['DOCKER_USER']} -p #{ENV['DOCKER_PW']} -e #{ENV['DOCKER_EMAIL']}
      docker tag base_image chef/docker_demo_base
      docker tag mongodb_base_image chef/docker_demo_mongodb_base
      docker push chef/docker_demo_base
      docker push chef/docker_demo_mongodb_base
    )
  end

  desc 'cheat', 'Pulls the base images down from Docker Index'
  def cheat
    exec %Q(
      docker login -u #{ENV['DOCKER_USER']} -p #{ENV['DOCKER_PW']} -e #{ENV['DOCKER_EMAIL']}
      docker pull chef/docker_demo_base
      docker pull chef/docker_demo_mongodb_base
      docker tag chef/docker_demo_base base_image
      docker tag chef/docker_demo_mongodb_base mongodb_base_image
    )
  end

  desc 'launch', 'Launches the Mongo Docker containers'
  def launch
    exec %Q(
      chef-client -z recipes/local_demo.rb
    )
  end

  desc 'prep', 'Preps your local environment'
  def prep
    exec %Q(
      boot2docker init
      boot2docker up
    )
  end

  desc 'cleanup', 'Cleanup your environment'
  def cleanup
    exec %Q(
      boot2docker stop
      boot2docker delete
      knife node delete base -y
      knife node delete mongodb_base -y
      knife node delete mongodb1 -y
      knife node delete mongodb2 -y
      knife node delete mongodb3 -y
      knife node delete mongodb4 -y
      knife node delete mongodb5 -y
    )
  end
end
