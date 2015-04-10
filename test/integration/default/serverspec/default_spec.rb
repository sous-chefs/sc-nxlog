require_relative 'spec_helper'

describe service('nxlog') do
  it { should be_enabled }
  it { should be_running }
end

input_contents = <<EOT
<Input mark>
  Module im_mark
  Mark -> -> MARK <- <-
  MarkInterval 1
</Input>

<Route r_mark>
  Path mark => test
</Route>
EOT

if os[:family] == 'windows'
  output_contents = <<EOT
<Output test>
  Module om_file
  File "c:/windows/temp/test.log"
</Output>
EOT
else
  output_contents = <<EOT
<Output test>
  Module om_file
  File "/var/log/nxlog/test.log"
</Output>
EOT
end

# redhat log config
describe file('/etc/nxlog.conf.d/op_test.conf'),
         if: %w(redhat fedora).include?(os[:family]) do
  it { should be_file }
  its(:content) { should match(output_contents) }
end

describe file('/etc/nxlog.conf.d/ip_mark.conf'),
         if: %w(redhat fedora).include?(os[:family]) do
  it { should be_file }
  its(:content) { should match(input_contents) }
end

# debian log config
describe file('/etc/nxlog/nxlog.conf.d/op_test.conf'),
         if: %w(ubuntu debian).include?(os[:family]) do
  it { should be_file }
  its(:content) { should match(output_contents) }
end

describe file('/etc/nxlog/nxlog.conf.d/ip_mark.conf'),
         if: %w(ubuntu debian).include?(os[:family]) do
  it { should be_file }
  its(:content) { should match(input_contents) }
end

# windows log config
describe file('c:/Program Files (x86)/nxlog/conf/nxlog.conf.d/' \
              'op_test.conf'),
         if: os[:family] == 'windows' do
  it { should be_file }
  its(:content) { should match(output_contents) }
end

describe file('c:/Program Files (x86)/nxlog/conf/nxlog.conf.d/' \
              'ip_mark.conf'),
         if: os[:family] == 'windows' do
  it { should be_file }
  its(:content) { should match(input_contents) }
end

# mark should occur after 60 seconds
$stderr.puts 'Sleeping for 70 seconds to collect log output'
sleep 70

describe file('/var/log/nxlog/test.log'),
         if: os[:family] != 'windows' do
  it { should be_file }
  its(:content) { should contain('-> -> MARK <- <-') }
end

describe file('c:/windows/temp/test.log'),
         if: os[:family] == 'windows' do
  it { should be_file }
  its(:content) { should contain('-> -> MARK <- <-') }
end
