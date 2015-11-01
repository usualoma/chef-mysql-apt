mysql-apt Cookbook
==================
Installs mysql server from [the MySQL APT repository](https://dev.mysql.com/downloads/repo/apt/) and configures initial root password.

Requirements
------------

#### packages
- `apt` - mysql-apt needs apt.

Attributes
----------

#### mysql-apt::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['mysql-apt']['version']</tt></td>
    <td>String</td>
    <td>MySQL version</td>
    <td><tt>5.7</tt></td>
  </tr>
  <tr>
    <td><tt>['mysql-apt']['initial_root_password']</tt></td>
    <td>String</td>
    <td>the initial root password for mysql when initializing new databases.</td>
    <td><tt>nil</tt><br />(This cookbook does not reset root password if this attribute is the nil. If you want to reset root password as blank, you should set blank string for this attribute.)</td>
  </tr>
</table>

Usage
-----
#### mysql-apt::default

Just include `mysql-apt` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[mysql-apt]"
  ]
}
```

Or, include sub resources explicitly.

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[mysql-apt::mysql-apt-config]",
    "recipe[mysql-apt::server]"
  ]
}
```

License and Authors
-------------------

Copyright (c) 2015 Taku AMANO.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
