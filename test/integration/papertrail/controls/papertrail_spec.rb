# frozen_string_literal: true

conf_dir = '/etc/nxlog'

nxlog_config_parse_opts = {
  assignment_regex: /^\s*([A-Za-z]+)\s+(.*?)\s*$/,
  group_re: /^\s*<([_A-Za-z0-9 ]+)>/,
}

control 'nxlog-papertrail-01' do
  impact 1.0
  title 'Papertrail bundle and destination are rendered'

  describe file("#{conf_dir}/certs/papertrail-bundle.pem") do
    it { should be_file }
    its('content') { should match(/test certificate/) }
  end

  describe parse_config_file("#{conf_dir}/nxlog.conf.d/10_op_papertrail.conf", nxlog_config_parse_opts) do
    its('Output papertrail.Module') { should eq 'om_ssl' }
    its('Output papertrail.Host') { should eq 'logs2.papertrailapp.com' }
    its('Output papertrail.Port') { should eq '17992' }
  end
end
