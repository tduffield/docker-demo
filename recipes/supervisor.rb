include_recipe 'supervisor'

directory "/var/run/sshd"

supervisor_service "sshd" do
  command "/usr/sbin/sshd -D"
  stdout_logfile "/var/log/supervisor/%(program_name)s.log"
  stderr_logfile "/var/log/supervisor/%(program_name)s.log"
  autorestart true
end

#supervisor_service "mongodb" do
#  command "/usr/bin/mongod -f /etc/mongodb.conf"
#  stdout_logfile "/var/log/supervisor/%(program_name)s.log"
#  stderr_logfile "/var/log/supervisor/%(program_name)s.log"
#  autorestart true
#end

#supervisor_service "chef-client" do
#  command "/opt/chef/bin/chef-client -l info -i 300"
#  stdout_logfile "/var/log/supervisor/%(program_name)s.log"
#  stderr_logfile "/var/log/supervisor/%(program_name)s.log"
#  autostart false
#  autorestart false
#end

directory "/home/docker"

user "docker" do
  shell "/bin/bash"
  home "/home/docker"
  supports :manage_home => true
end

execute 'echo "docker:docker" | chpasswd'

execute 'sudo adduser docker sudo'
