#
# Cookbook:: openttd
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
#
docker_service 'default' do
  action [:create, :start]
end

docker_image 'bateau/openttd' do
  action :pull
end

group 'docker' do
  append true
  members 'ubuntu'
  action :manage
end

compose_version = '1.22.0'
compose_url = "https://github.com/docker/compose/releases/download/#{compose_version}/docker-compose-Linux-x86_64"

remote_file '/usr/local/bin/docker-compose' do
  source compose_url
  checksum 'f679a24b93f291c3bffaff340467494f388c0c251649d640e661d509db9d57e9'
  mode '0755'
end

template '/home/ubuntu/docker-compose.yml' do
  source 'docker-compose.yml.erb'
  owner 'ubuntu'
  group 'ubuntu'
end

server_password = Chef::EncryptedDataBagItem.load("openttd", "server_password").to_hash['value']
rcon_password = Chef::EncryptedDataBagItem.load("openttd", "rcon_password").to_hash['value']
admin_password = Chef::EncryptedDataBagItem.load("openttd", "admin_password").to_hash['value']

directory '/home/ubuntu/openttd' do
  owner 'ubuntu'
  group 'ubuntu'
end

template '/home/ubuntu/openttd/openttd.cfg' do
  source 'openttd.cfg.erb'
  owner 'ubuntu'
  group 'ubuntu'
  variables(
    server_password: server_password,
    rcon_password: rcon_password,
    admin_password: admin_password
  )
  notifies :run, 'execute[start_openttd]', :delayed
end

execute 'start_openttd' do
  command 'docker-compose -f /home/ubuntu/docker-compose.yml restart || docker-compose -f /home/ubuntu/docker-compose.yml up -d'
end
