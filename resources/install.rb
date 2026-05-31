# frozen_string_literal: true

provides :nxlog_install
unified_mode true
include ScNxLog::Helpers

property :version, String, default: '3.2.2329'
property :package_source, String, default: 'https://mirror.widgit.com/nxlog'
property :package_name, String, default: lazy { default_package_name }
property :package_checksum, [String, nil]
property :install_package, [true, false], default: true
property :manage_service, [true, false], default: true
property :conf_dir, String, default: lazy { default_conf_dir }
property :root_dir, String, default: lazy { default_root_dir }
property :log_file, String, default: lazy { default_log_file }
property :log_level, String, default: 'INFO'
property :user, String, default: 'nxlog'
property :group, String, default: 'nxlog'

action_class do
  include ScNxLog::Helpers
end

action :install do
  remote_file 'nxlog package' do
    path package_path
    source "#{new_resource.package_source}/#{new_resource.package_name}"
    checksum new_resource.package_checksum if new_resource.package_checksum
    mode '0644'
    action :create
    only_if { new_resource.install_package }
  end

  if platform_family?('debian')
    dpkg_package 'nxlog' do
      source package_path
      options '--force-confold'
      action :install
      only_if { new_resource.install_package }
    end
  elsif platform_family?('windows')
    windows_package 'nxlog' do
      source package_path
      action :install
      only_if { new_resource.install_package }
    end
  else
    package 'nxlog' do
      source package_path
      action :install
      only_if { new_resource.install_package }
    end
  end

  directory new_resource.conf_dir do
    recursive true
    action :create
  end

  directory "#{new_resource.conf_dir}/nxlog.conf.d" do
    recursive true
    action :create
  end

  directory ::File.dirname(new_resource.log_file) do
    recursive true
    action :create
    not_if { platform?('windows') }
  end

  service 'nxlog' do
    supports status: true, restart: true
    action :nothing
  end

  template "#{new_resource.conf_dir}/nxlog.conf" do
    cookbook 'sc-nxlog'
    source 'nxlog.conf.erb'
    variables(
      conf_dir: new_resource.conf_dir,
      group: new_resource.group,
      log_file: new_resource.log_file,
      log_level: new_resource.log_level,
      root_dir: new_resource.root_dir,
      user: new_resource.user
    )
    action :create
    notifies :restart, 'service[nxlog]', :delayed if new_resource.manage_service
  end

  service 'nxlog' do
    supports status: true, restart: true
    action %i(enable start)
    only_if { new_resource.manage_service }
  end
end

action :remove do
  service 'nxlog' do
    supports status: true, restart: true
    action %i(stop disable)
    only_if { new_resource.manage_service }
  end

  file "#{new_resource.conf_dir}/nxlog.conf" do
    action :delete
  end

  directory "#{new_resource.conf_dir}/nxlog.conf.d" do
    recursive true
    action :delete
  end

  if platform_family?('debian')
    dpkg_package 'nxlog' do
      action :remove
      only_if { new_resource.install_package }
    end
  elsif platform_family?('windows')
    windows_package 'nxlog' do
      action :remove
      only_if { new_resource.install_package }
    end
  else
    package 'nxlog' do
      action :remove
      only_if { new_resource.install_package }
    end
  end
end
