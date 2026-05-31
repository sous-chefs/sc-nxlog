# frozen_string_literal: true

conf_dir = '/etc/nxlog'

nxlog_config_parse_opts = {
  assignment_regex: /^\s*([A-Za-z]+)\s+(.*?)\s*$/,
  group_re: /^\s*<([_A-Za-z0-9 ]+)>/,
}

control 'nxlog-syslog-01' do
  impact 1.0
  title 'Syslog input and route are rendered'

  describe file('/dev/log') do
    it { should be_symlink }
  end

  describe parse_config_file("#{conf_dir}/nxlog.conf.d/20_ip_syslog.conf", nxlog_config_parse_opts) do
    its('Input syslog.Module') { should eq 'im_uds' }
    its('Input syslog.Exec') { should eq 'parse_syslog_bsd();' }
    its('Input syslog.FlowControl') { should eq 'FALSE' }
    its('Input syslog.UDS') { should eq '/var/run/nxlog/devlog' }
    its('Route r_syslog.Path') { should eq 'syslog => test' }
  end
end
