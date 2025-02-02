#
# Author:: Steven Danna(<steve@opscode.com>)
# Cookbook Name:: R
# Recipe:: default
#
# Copyright 2011-2013, Steven S. Danna (<steve@opscode.com>)
# Copyright 2013, Mark Van de Vyver (<mark@taqtiqa.com>)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

chef_gem "rinruby"

if node['r']['install_repo']
  include_recipe "r::repo"
end

include_recipe "r::install_#{node['r']['install_method']}"

# Add r to all users path because /usr/local/bin may not be the default on all systems
if node['r']['add_r_to_path']
  template "/etc/profile.d/r.sh" do
    mode "0755"
  end
end

# Setting the default CRAN mirror makes
# remote administration of R much easier.
template "#{node['r']['install_dir']}/etc/Rprofile.site" do
  mode "0555"
  variables(:cran_mirror => node['r']['cran_mirror'])
end

# set environment variables
template "#{node['r']['install_dir']}/etc/Renviron.site" do
  mode "0644"
end

node['r']['libraries'].each do |library|
  r_package library['name'] do
    package_path library['package_path'] if library['package_path']
    version library['version'] if library['version']
    
    if library['update_method'] == 'always_update'
      action :upgrade
    else
      action :install
    end

    only_if { ::File.exists?("#{node['r']['install_dir']}/etc/Rprofile.site") }
  end
end


