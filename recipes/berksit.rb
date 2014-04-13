source_path = File.expand_path('../..', __FILE__)

execute 'berks install' do
  cwd source_path
end

execute 'berks upload --no-ssl-verify' do
  cwd source_path
end
