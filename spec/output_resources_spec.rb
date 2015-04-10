require_relative 'spec_helper'

describe 'nxlog_ce::test_output_resources' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['nxlog_ce_destination'])
      .converge(described_recipe)
  end

  it 'creates a log destination for a file' do
    expect(chef_run).to create_nxlog_ce_destination('test_om_file')
  end

  it 'creates a config file for the file log destination' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/op_test_om_file.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/op_test_om_file.conf')
      .with_content(<<EOT)
<Output test_om_file>
  Module om_file
  File "/var/log/test.log"
</Output>
EOT
  end

  it 'creates a log destination for the blocker module' do
    expect(chef_run).to create_nxlog_ce_destination('test_om_blocker')
  end

  it 'creates a config file for the blocker module' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/op_test_om_blocker.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/op_test_om_blocker.conf')
      .with_content(<<EOT)
<Output test_om_blocker>
  Module om_blocker
</Output>
EOT
  end

  it 'creates a log destination for the dbi module' do
    expect(chef_run).to create_nxlog_ce_destination('test_om_dbi')
  end

  it 'creates a config file for the dbi module' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/op_test_om_dbi.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/op_test_om_dbi.conf')
      .with_content(<<EOT)
<Output test_om_dbi>
  Module om_dbi
  Driver mysql
  SQL INSERT INTO log VALUES ($SyslogFacility, $SyslogSeverity, $Message)
  Option host 127.0.0.1
  Option username foo
  Option password bar
  Option dbname nxlog
</Output>
EOT
  end

  it 'creates a log destination for the exec module' do
    expect(chef_run).to create_nxlog_ce_destination('test_om_exec')
  end

  it 'creates a config file for the exec module' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/op_test_om_exec.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/op_test_om_exec.conf')
      .with_content(<<EOT)
<Output test_om_exec>
  Module om_exec
  Command /usr/bin/foo
  Arg bar
  Arg baz
</Output>
EOT
  end

  it 'creates log destinations for the http module' do
    expect(chef_run).to create_nxlog_ce_destination('test_om_http')
    expect(chef_run).to create_nxlog_ce_destination('test_om_https')
  end

  it 'creates config files for the http modules' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/op_test_om_http.conf')
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/op_test_om_https.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/op_test_om_http.conf')
      .with_content(<<EOT)
<Output test_om_http>
  Module om_http
  Url http://example.org/bar
</Output>
EOT

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/op_test_om_https.conf')
      .with_content(<<EOT)
<Output test_om_https>
  Module om_http
  Url https://example.org/foo
  HTTPSCertFile %CERTDIR%/client-cert.pem
  HTTPSCertKeyFile %CERTDIR%/client-key.pem
  HTTPSCAFile %CERTDIR%/ca.pem
  HTTPSAllowUntrusted FALSE
</Output>
EOT
  end

  it 'creates a log destination for the null module' do
    expect(chef_run).to create_nxlog_ce_destination('test_om_null')
  end

  it 'creates a config file for the null module' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/op_test_om_null.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/op_test_om_null.conf')
      .with_content(<<EOT)
<Output test_om_null>
  Module om_null
</Output>
EOT
  end

  it 'creates a log destination for the ssl module' do
    expect(chef_run).to create_nxlog_ce_destination('test_om_ssl')
  end

  it 'creates a config file for the ssl module' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/op_test_om_ssl.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/op_test_om_ssl.conf')
      .with_content(<<EOT)
<Output test_om_ssl>
  Module om_ssl
  OutputType Binary
  Host foo.example.org
  Port 1234
  CertFile %CERTDIR%/client-cert.pem
  CertKeyFile %CERTDIR%/client-key.pem
  CAFile %CERTDIR%/ca.pem
  AllowUntrusted FALSE
</Output>
EOT
  end

  it 'creates a log destination for the tcp module' do
    expect(chef_run).to create_nxlog_ce_destination('test_om_tcp')
  end

  it 'creates a config file for the tcp module' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/op_test_om_tcp.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/op_test_om_tcp.conf')
      .with_content(<<EOT)
<Output test_om_tcp>
  Module om_tcp
  Host foo.example.org
  Port 1234
</Output>
EOT
  end

  it 'creates a log destination for the udp module' do
    expect(chef_run).to create_nxlog_ce_destination('test_om_udp')
  end

  it 'creates a config file for the udp module' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/op_test_om_udp.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/op_test_om_udp.conf')
      .with_content(<<EOT)
<Output test_om_udp>
  Module om_udp
  Host foo.example.org
  Port 1234
</Output>
EOT
  end

  it 'creates a log destination for the uds module' do
    expect(chef_run).to create_nxlog_ce_destination('test_om_uds')
  end

  it 'creates a config file for the uds module' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/op_test_om_uds.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/op_test_om_uds.conf')
      .with_content(<<EOT)
<Output test_om_uds>
  Module om_uds
  Exec parse_syslog_bsd(); to_syslog_bsd();
  uds /dev/log
</Output>
EOT
  end
end
