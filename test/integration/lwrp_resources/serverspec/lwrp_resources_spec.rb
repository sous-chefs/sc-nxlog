require_relative 'spec_helper'

describe service('nxlog') do
  it { should be_enabled }
  it { should be_running }
end

case os[:family]
when 'debian', 'ubuntu'
  conf_dir = '/etc/nxlog'
  log_dir = '/var/log/nxlog'
  a_prefix = ''
when 'redhat'
  conf_dir = '/etc'
  log_dir = '/var/log/nxlog'
  a_prefix = ''
when 'windows'
  conf_dir = 'c:/Program Files (x86)/nxlog/conf'
  log_dir = 'c:/windows/temp'
  a_prefix = '\\\\'
else
  Chef::Application.fatal!('Attempted to install on an unsupported platform')
end

describe file("#{conf_dir}/nxlog.conf.d/10_op_test.conf") do
  it { should be_file }
  its(:content) { should start_with(<<EOT) }
<Output test>
  Module om_file
  File "#{log_dir}/test.log"
</Output>
EOT
end

describe file("#{conf_dir}/nxlog.conf.d/10_op_test_2.conf") do
  it { should be_file }
  its(:content) { should start_with(<<EOT) }
<Output test_2>
  Module om_file
  File "#{log_dir}/test2.log"
</Output>
EOT
end

describe file("#{conf_dir}/nxlog.conf.d/10_op_papertrail.conf") do
  it { should be_file }
  its(:content) { should start_with(<<EOT) }
<Output papertrail>
  Module om_ssl
  Exec $Hostmame = hostname(); to_syslog_ietf();
  Host logs2.papertrailapp.com
  Port 17992
  CAFile #{conf_dir}/certs/papertrail-bundle.pem
  AllowUntrusted FALSE
</Output>
EOT
end

describe file("#{conf_dir}/nxlog.conf.d/op_test_2.default") do
  it { should be_file }
  its(:content) { should start_with(<<EOT) }
define DEFAULT_OUTPUTS %DEFAULT_OUTPUTS%, test_2
EOT
end

describe file("#{conf_dir}/nxlog.conf.d/20_ip_mark.conf") do
  it { should be_file }
  its(:content) { should start_with(<<EOT) }
define DEFAULT_OUTPUTS null_output

include #{conf_dir}/nxlog.conf.d/#{a_prefix}*.default

<Input mark>
  Module im_mark
  Mark -> -> MARK <- <-
  MarkInterval 1
</Input>

<Route r_mark>
  Path mark => test, %DEFAULT_OUTPUTS%
</Route>
EOT
end

describe file("#{log_dir}/test.log") do
  it { should be_file }
  its(:content) { should contain('-> -> MARK <- <-') }
end

describe file("#{log_dir}/test2.log") do
  it { should be_file }
  its(:content) { should contain('-> -> MARK <- <-') }
end

describe file("#{conf_dir}/certs/papertrail-bundle.pem") do
  it { should be_file }
  its(:content) { should contain('ca-bundle.crt') }
end
