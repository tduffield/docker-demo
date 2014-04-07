#!bash
mkdir -p ~/mongotest/repo
rm -rf ~/mongotest/repo/cookbooks
berks vendor ~/mongotest/repo/cookbooks
pushd ~/mongotest/repo
chef-client -z -o docker-demo::vagrant,docker-demo::mongo_cluster
