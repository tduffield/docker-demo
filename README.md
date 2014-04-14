# docker-demo-cookbook

## DISCLAIMER
*THIS IS A DEMO*. Run this code in any way other than described and your 
air conditioning will fail, your refrigerator will turn off, and bacon will 
forever taste like escargot.

## Live Demo

### Step Zero: Launch EC2 Instances (done beforehand)

    chef-client -z recipes/create_provisioner.rb
    chef-client -z recipes/create_mongohost_ec2.rb

### Step One: Create container image

    knife node run_list add provisioner recipe[docker-demo::create_mongodb_image]

### Step Two: Create host environment

    knife node run_list add provisioner recipe[docker-demo::create_mongodb_host]

### Step Two and 1/2: Save image to Docker Index (Beforehand)

    docker tag mongodb_image chef/mongodb_image
    docker push chef/mongodb_image

### Step Three: Launch MongoDB Containers

    knife node run_list add mongodb_host recipe[docker-demo::mongodb_host] 

## Running the Local Demo on a Mac
*The local demo is designed to run on a Mac running boot2docker*

This demo requires that you use a Chef Server (no chef-zero or chef-solo) supported,
so please make sure to have your knife configuration setup correctly. In addition, we run
the initial command in chef-client local mode but the containers run against your Chef Server. 
This means that we need to pass the Chef Server URL to the recipe. To do this, we are using an 
environment variable. 

    export DOCKER_CHEF_SERVER=http://chef.example.com/organizations/you

Because Docker support is still young, some edits to community cookbooks were necessary to make
the demo work. These cookbooks are referenced in our `Berksfile`.

    $ berks install
    $ berks upload

If you want to push/pull images that are stored on the Docker index, you will need
Docker credentials. For purposes of this demo, those credentials are being stored
in environment variables.

    export DOCKER_USER=<your user>
    export DOCKER_PW=<your pw>
    export DOCKER_EMAIL=<your email>

The local demo assumes that you have Docker installed. If you do not have Docker installed, 
please follow the instructions here: [Docker Installation Documentation](https://www.docker.io/gettingstarted/#h_installation).

1. To prep your local workstation, run the `thor demo:prep` command. This will setup boot2docker.
2. Download the necessary images.
  1. If you want to build all the images from scratch, run `thor demo:factory`
  2. If you want to download the base and mongodb images, run `thor demo:cheat`
3. Launch your MongoDB cluster by running `thor demo:launch`

You can confirm if your cluster is working by SSH-ing into a container. To do this, first SSH
into boot2docker by running `boot2docker ssh`. The password is tcuser. Then, you can ssh into any one
of the Docker containers currently running. To see the running containers, run `docker ps`. 

    CONTAINER ID        IMAGE                   COMMAND             CREATED             STATUS              PORTS                                               NAMES
    fa37ebf284ae        mongodb5_image:latest   supervisord -n      2 minutes ago       Up 2 minutes        127.0.0.1:22005->22/tcp, 0.0.0.0:27025->27025/tcp   mongodb5
    deefc7b18996        mongodb4_image:latest   supervisord -n      3 minutes ago       Up 3 minutes        127.0.0.1:22004->22/tcp, 0.0.0.0:27024->27024/tcp   mongodb4
    4c6761032a8c        mongodb3_image:latest   supervisord -n      3 minutes ago       Up 3 minutes        127.0.0.1:22003->22/tcp, 0.0.0.0:27023->27023/tcp   mongodb3
    6e5b6c53f8c2        mongodb2_image:latest   supervisord -n      4 minutes ago       Up 4 minutes        127.0.0.1:22002->22/tcp, 0.0.0.0:27022->27022/tcp   mongodb2
    da2561522ae2        mongodb1_image:latest   supervisord -n      5 minutes ago       Up 5 minutes        127.0.0.1:22001->22/tcp, 0.0.0.0:27021->27021/tcp   mongodb1

You can see in this printout that we are forwarding port 22 in the container to another port on the host. 
Specify that port when you are SSH-ing into the container as the docker user. 

    $ ssh docker@localhost -p 22001

The password for the docker user is `docker`.

No you can login to the mongo CLI to check the replicaset configuration. 

    $ mongo localhost:27021/admin
    MongoDB shell version: 2.0.4
    connecting to: localhost:27021/admin
    SECONDARY> rs.conf()
    {
      "_id" : "docker",
      "version" : 6,
      "members" : [
        {
          "_id" : 0,
          "host" : "172.17.0.2:27021"
        },
        {
          "_id" : 1,
          "host" : "172.17.0.3:27022"
        },
        {
          "_id" : 2,
          "host" : "172.17.0.4:27023"
        },
        {
          "_id" : 4,
          "host" : "172.17.0.6:27025"
        },
        {
          "_id" : 5,
          "host" : "172.17.0.5:27024"
        }
      ]
    }

If everything was successful, you should see all five Docker containers listed. 



