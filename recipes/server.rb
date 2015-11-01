#
# Cookbook Name:: mysql-apt
# Recipe:: server
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

package 'mysql-server' do
  action :install
  notifies :run, 'execute[improve security]', :immediately
  notifies :run, 'execute[set initial root password]', :immediately
end

execute 'improve security' do
  command <<COMMAND
mysql -e " \
DELETE FROM mysql.user WHERE USER LIKE ''; \
DELETE FROM mysql.user WHERE user = 'root' and host NOT IN ('127.0.0.1', 'localhost', '::1'); \
FLUSH PRIVILEGES; \
DELETE FROM mysql.db WHERE db LIKE 'test%'; \
DROP DATABASE IF EXISTS test; \
"
COMMAND
  user 'root'
  only_if "mysql -e 'SELECT 1'"
  action :nothing
end

execute 'set initial root password' do
  environment({
    'PASS' => node['mysql-apt']['initial_root_password'],
  })
  command <<COMMAND
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$PASS'" || \
mysql -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$PASS');"
COMMAND
  user 'root'
  only_if "mysql -e 'SELECT 1'"
  not_if { node['mysql-apt']['initial_root_password'].nil? }
  action :nothing
end

service 'mysql' do
  action [:enable, :start]
end
