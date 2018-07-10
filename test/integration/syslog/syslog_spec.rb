describe service('nxlog') do
  it { should be_enabled }
  it { should be_running }
end

describe service('rsyslog') do
  it { should_not be_running }
  it { should_not be_enabled }
end

case os[:family]
when 'debian', 'ubuntu'
  conf_dir = '/etc/nxlog'
when 'redhat'
  conf_dir = '/etc'
else
  Chef::Application.fatal!('Attempted to install on an unsupported platform')
end

describe file('/var/run/nxlog/devlog') do
  it { should be_socket }
end

describe.one do
  describe file('/dev/log') do
    it { should be_symlink }
    # its('shallow_link_path') { should eq '/var/run/nxlog/devlog' }
    its('link_path') { should eq '/run/nxlog/devlog' }
  end
  describe file('/dev/log') do
    it { should be_symlink }
    # its('shallow_link_path') { should eq '/var/run/nxlog/devlog' }
    its('link_path') { should eq '/var/run/nxlog/devlog' }
  end
end

nxlog_config_parse_opts = {
  assignment_regex: /^\s*([A-Za-z]+)\s+(.*?)\s*$/,
  group_re: /^\s*<([_A-Za-z0-9 ]+)>/,
}

describe parse_config_file("#{conf_dir}/nxlog.conf.d/10_op_test.conf", nxlog_config_parse_opts) do
  its('Output test.Module') { should eq 'om_file' }
  its('Output test.File')   { should eq '"/tmp/test.log"' }
end

describe parse_config_file("#{conf_dir}/nxlog.conf.d/20_ip_syslog.conf", nxlog_config_parse_opts) do
  its('define')  { should eq 'DEFAULT_OUTPUTS null_output' }
  its('include') { should eq "#{conf_dir}/nxlog.conf.d/*.default" }

  its('Input syslog.Module') { should eq 'im_uds' }
  its('Input syslog.Exec')   { should eq 'parse_syslog_bsd();' }
  its('Input syslog.FlowControl') { should eq 'FALSE' }
  its('Input syslog.UDS') { should eq '/var/run/nxlog/devlog' }

  its('Route r_syslog.Path') { should eq 'syslog => test' }
end
