#
# Cookbook Name:: swift
# Recipe:: default
#
# Copyright 2012, sw maestro
#
# All rights reserved - Do Not Redistribute
#

#execute "sudo apt-get update" do
#end

%w{swift openssh-server sshpass}.each do |pkg|
  package pkg
end

directory "/etc/swift" do
  owner node[:storage][:user]
  group node[:storage][:group]
  mode "0755"
  recursive true
end


template "/etc/swift/swift.conf" do
  source "swift.conf.erb"
  owner node[:storage][:user]
  group node[:storage][:group]
  mode "0755"
end


[
  "export STORAGE_LOCAL_IP=#{node["ipaddress"]}",
  "export PROXY_LOCAL_IP=#{node[:storage][:proxy][:ip]}"
].each do |bash|
  execute "echo '#{bash}' >> ~/.bashrc" do
    not_if "grep '#{bash}' ~/.bashrc"
  end
end


execute ". ~/.bashrc" do
  not_if { File.exists?("~/.bashrc") }
end
