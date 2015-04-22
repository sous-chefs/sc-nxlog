require_relative 'spec_helper'

describe service('nxlog') do
  it { should be_enabled }
  it { should be_running }
end

case os[:family]
when 'debian', 'ubuntu'
  conf_dir = '/etc/nxlog'
  log_dir = '/var/log/nxlog'
when 'redhat'
  conf_dir = '/etc'
  log_dir = '/var/log/nxlog'
when 'windows'
  if os[:arch] == 'x86_64'
    conf_dir = 'c:/Program Files (x86)/nxlog/conf'
  else
    conf_dir = 'c:/Program Files/nxlog'
  end
  log_dir = 'c:/windows/temp'
else
  Chef::Application.fatal!('Attempted to install on an unsupported platform')
end

describe file("#{conf_dir}/nxlog.conf.d/10_op_test.conf") do
  it { should be_file }
  its(:content) { should match(<<EOT) }
<Output test>
  Module om_file
  File "#{log_dir}/test.log"
</Output>
EOT
end

describe file("#{conf_dir}/nxlog.conf.d/10_op_test_2.conf") do
  it { should be_file }
  its(:content) { should match(<<EOT) }
<Output test_2>
  Module om_file
  File "#{log_dir}/test2.log"
</Output>
EOT
end

describe file("#{conf_dir}/nxlog.conf.d/op_test_2.default") do
  it { should be_file }
  its(:content) { should match(<<EOT) }
define DEFAULT_OUTPUTS %DEFAULT_OUTPUTS%, test_2
EOT
end

describe file("#{conf_dir}/nxlog.conf.d/20_ip_mark.conf") do
  it { should be_file }
  its(:content) { should match(<<EOT) }
define DEFAULT_OUTPUTS null_output

include #{conf_dir}/nxlog.conf.d/op_*.default

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
