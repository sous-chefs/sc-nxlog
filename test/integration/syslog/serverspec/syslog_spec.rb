require_relative 'spec_helper'

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

describe file('/dev/log') do
  it { should be_symlink }
  it { should be_linked_to '/var/run/nxlog/devlog' }
end

describe file("#{conf_dir}/nxlog.conf.d/10_op_test.conf") do
  it { should be_file }
  its(:content) { should start_with(<<EOT) }
<Output test>
  Module om_file
  File "/tmp/test.log"
</Output>
EOT
end

describe file("#{conf_dir}/nxlog.conf.d/20_ip_syslog.conf") do
  it { should be_file }
  its(:content) { should start_with(<<EOT) }
define DEFAULT_OUTPUTS null_output

include #{conf_dir}/nxlog.conf.d/*.default

<Input syslog>
  Module im_uds
  Exec parse_syslog_bsd();
  FlowControl FALSE
  UDS /var/run/nxlog/devlog
</Input>

<Route r_syslog>
  Path syslog => test
</Route>
EOT
end

describe file('/tmp/test.log') do
  it { should be_file }
  its(:content) { should contain('sudo:') }
end
