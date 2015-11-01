#
# Cookbook Name:: mysql-apt
# Recipe:: mysql-apt-config
#
# Copyright (c) 2015 Taku AMANO. All rights reserved.
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

include_recipe 'apt'

version  = node['mysql-apt']['version']
deb_url  = node['mysql-apt']['apt-config-deb-url']
deb_file = "#{Chef::Config[:file_cache_path]}/#{File.basename deb_url}"

remote_file deb_file do
  source deb_url
  action :create
end

file deb_file do
  action :nothing
  checksum node['mysql-apt']['apt-config-deb-checksum']
end

dpkg_package 'mysql-apt-config' do
  source deb_file
  action :install
  notifies :run, 'execute[apt-get update]', :immediately
end

execute 'debconf-set-selections mysql-apt-config' do
  command %Q{echo "mysql-apt-config mysql-apt-config/select-server select mysql-#{version}" | debconf-set-selections}
  not_if %Q{debconf-get-selections | grep "mysql-apt-config.*mysql-apt-config/select-server.*mysql-#{version}"}
  notifies :remove, 'dpkg_package[mysql-apt-config]', :immediately
  notifies :install, 'dpkg_package[mysql-apt-config]', :immediately
end
