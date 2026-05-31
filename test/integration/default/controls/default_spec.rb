# frozen_string_literal: true

conf_dir = '/etc/nxlog'

nxlog_config_parse_opts = {
  assignment_regex: /^\s*([A-Za-z]+)\s+(.*?)\s*$/,
  group_re: /^\s*<([_A-Za-z0-9 ]+)>/,
}

control 'nxlog-default-01' do
  impact 1.0
  title 'NXLog main configuration exists'

  describe file("#{conf_dir}/nxlog.conf") do
    it { should exist }
    its('content') { should match(%r{Include   /etc/nxlog/nxlog.conf.d/\*\.conf}) }
    its('content') { should match(/LogLevel  INFO/) }
  end
end

control 'nxlog-default-02' do
  impact 1.0
  title 'NXLog destination resources render output snippets'

  describe parse_config_file("#{conf_dir}/nxlog.conf.d/10_op_test.conf", nxlog_config_parse_opts) do
    its('Output test.Module') { should eq 'om_file' }
    its('Output test.File') { should eq '"/var/log/nxlog/test.log"' }
  end

  describe parse_config_file("#{conf_dir}/nxlog.conf.d/op_test_2.default", nxlog_config_parse_opts) do
    its('define') { should eq 'DEFAULT_OUTPUTS %DEFAULT_OUTPUTS%, test_2' }
  end
end

control 'nxlog-default-03' do
  impact 1.0
  title 'NXLog source resources render input routes'

  describe parse_config_file("#{conf_dir}/nxlog.conf.d/20_ip_mark.conf", nxlog_config_parse_opts) do
    its('define') { should eq 'DEFAULT_OUTPUTS null_output' }
    its('include') { should eq '/etc/nxlog/nxlog.conf.d/*.default' }
    its('Input mark.Module') { should eq 'im_mark' }
    its('Input mark.Mark') { should eq '-> -> MARK <- <-' }
    its('Input mark.MarkInterval') { should eq '1' }
    its('Route r_mark.Path') { should eq 'mark => test, %DEFAULT_OUTPUTS%' }
  end
end
