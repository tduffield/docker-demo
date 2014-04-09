include_recipe 'supervisor'

supervisor_service "sshd" do
  command "/usr/bin/sshd -d"
  stdout_logfile "/var/log/supervisor/%(program_name)s.log"
  stderr_logfile "/var/log/supervisor/%(program_name)s.log"
  autorestart true
end

supervisor_service "mongodb" do
  command "/usr/bin/mongod -f /etc/mongodb.conf"
  stdout_logfile "/var/log/supervisor/%(program_name)s.log"
  stderr_logfile "/var/log/supervisor/%(program_name)s.log"
  autorestart true
end
