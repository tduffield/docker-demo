# docker-demo-cookbook

## DISCLAIMER
*THIS IS A DEMO*. Run this code in any way other than described and your 
air conditioning will fail, your refrigerator will turn off, and bacon will 
forever taste like escargot.

## Running the Local Demo on a Mac
*The local demo is designed to run on a Mac running boot2docker*

This demo requires that you use a Chef Server (no chef-zero or chef-solo) supported,
so please make sure to have your knife configuration setup correctly.

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

You can see in this printout that we are forwarding port 22 in the container to another port on the host. 
Specify that port when you are SSH-ing into the container as the docker user. 

    $ ssh docker@localhost -p 22001

The password for the docker user is `docker`.

No you can login to the mongo CLI to check the replicaset configuration. 

    $ mongo localhost:27021/admin

    > rs.conf()

If everything was successful, you should see all five Docker containers listed. 



