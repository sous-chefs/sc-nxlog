# frozen_string_literal: true

module ScNxLog
  DEFAULTS_KEY = 'defaults'

  module Helpers
    def default_conf_dir
      platform?('windows') ? "#{default_root_dir}/conf" : '/etc/nxlog'
    end

    def default_log_file
      platform?('windows') ? "#{default_root_dir}/nxlog.log" : '/var/log/nxlog/nxlog.log'
    end

    def default_root_dir
      if node['kernel'] && node['kernel']['machine'] == 'x86_64'
        'c:/Program Files (x86)/nxlog'
      else
        'c:/Program Files/nxlog'
      end
    end

    def default_package_name
      case node['platform_family']
      when 'debian'
        if platform?('ubuntu')
          "nxlog-ce_#{version}_ubuntu22_amd64.deb"
        else
          "nxlog-ce_#{version}_debian11_amd64.deb"
        end
      when 'rhel', 'fedora', 'amazon'
        "nxlog-ce-#{version}_rhel9.x86_64.rpm"
      when 'windows'
        "nxlog-ce-#{version}.msi"
      else
        raise "Unsupported platform family: #{node['platform_family']}"
      end
    end

    def package_path
      ::File.join(Chef::Config[:file_cache_path], new_resource.package_name)
    end

    def config_include_glob
      if platform?('windows')
        "#{new_resource.conf_dir}/nxlog.conf.d/\\\\*.default"
      else
        "#{new_resource.conf_dir}/nxlog.conf.d/*.default"
      end
    end
  end
end
