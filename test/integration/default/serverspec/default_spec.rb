require_relative 'spec_helper'

describe service('nxlog') do
  it { should be_enabled }
  it { should be_running }
end

# log output config file

describe file('/etc/nxlog.conf.d/op_syslog_out.conf'),
         if: %w(redhat fedora).include?(os[:family]) do
  it { should be_file }
  its(:content) { should match(<<EOT) }
<Output syslog_out>
  Module om_file
  File "/var/log/test.log"
</Output>
EOT
end

describe file('/etc/nxlog/nxlog.conf.d/op_syslog_out.conf'),
         if: %w(ubuntu debian).include?(os[:family]) do
  it { should be_file }
  its(:content) { should match(<<EOT) }
<Output syslog_out>
  Module om_file
  File "/var/log/test.log"
</Output>
EOT
end

describe file('c:/Program Files (x86)/nxlog/conf/nxlog.conf.d/op_syslog_out.conf'),
         if: os[:family] == 'windows' do
  it { should be_file }
  its(:content) { should match(<<EOT) }
<Output syslog_out>
  Module om_file
  File "c:/windows/temp/test.log"
</Output>
EOT
end

# log output file

# describe file('/var/log/test.log'),
#          if: os[:family] != 'windows' do
#   it { should be_file }
#   its(:content) { should contain(/Something predictable from syslog/) }
# end

# describe file('c:/windows/temp/test.log'),
#          if: os[:family] == 'windows' do
#   it { should be_file }
#   its(:content) { should contain(/Something predictable from syslog/) }
# end
