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
  raise('Attempted to install on an unsupported platform')
end

nxlog_config_parse_opts = {
  assignment_regex: /^\s*([A-Za-z]+)\s+(.*?)\s*$/,
  group_re: /^\s*<([_A-Za-z0-9 ]+)>/,
}

describe parse_config_file("#{conf_dir}/nxlog.conf.d/10_op_test.conf", nxlog_config_parse_opts) do
  its('Output test.Module') { should eq 'om_file'                 }
  its('Output test.File')   { should eq "\"#{log_dir}/test.log\"" }
end

describe parse_config_file("#{conf_dir}/nxlog.conf.d/10_op_test_2.conf", nxlog_config_parse_opts) do
  its('Output test_2.Module') { should eq 'om_file' }
  its('Output test_2.File')   { should eq "\"#{log_dir}/test2.log\"" }
end

describe parse_config_file("#{conf_dir}/nxlog.conf.d/op_test_2.default", nxlog_config_parse_opts) do
  its('define') { should eq 'DEFAULT_OUTPUTS %DEFAULT_OUTPUTS%, test_2' }
end

describe parse_config_file("#{conf_dir}/nxlog.conf.d/20_ip_mark.conf", nxlog_config_parse_opts) do
  its('define') { should eq 'DEFAULT_OUTPUTS null_output' }
  its('include') { should eq "#{conf_dir}/nxlog.conf.d/#{a_prefix}*.default" }

  its('Input mark.Module') { should eq 'im_mark' }
  its('Input mark.Mark') { should eq '-> -> MARK <- <-' }
  its('Input mark.MarkInterval') { should eq '1' }

  its('Route r_mark.Path') { should eq 'mark => test, %DEFAULT_OUTPUTS%' }
end
