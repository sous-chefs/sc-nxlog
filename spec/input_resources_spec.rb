require_relative 'spec_helper'

describe 'nxlog_ce::test_input_resources' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['nxlog_ce_source'])
      .converge(described_recipe)
  end

  it 'creates a log source for a file' do
    expect(chef_run).to create_nxlog_ce_source('test_im_file')
  end

  it 'creates a config file for the file log source' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_file.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_file.conf')
      .with_content(<<EOT)
<Input test_im_file>
  Module im_file
  CloseWhenIdle false
  PollInterval 5.5
  File "/var/log/test.log"
</Input>
EOT
  end

  it 'creates a config file for the exec log source' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_exec.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_exec.conf')
      .with_content(<<EOT)
<Input test_im_exec>
  Module im_exec
  Command /sbin/log_processor
  Arg foo
  Arg ba
  Arg baz
</Input>
EOT
  end

  it 'creates a config file for the internal log source' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_internal.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_internal.conf')
      .with_content(<<EOT)
<Input test_im_internal>
  Module im_internal
</Input>
EOT
  end

  it 'creates a config file for the kernel log source' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_kernel.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_kernel.conf')
      .with_content(<<EOT)
<Input test_im_kernel>
  Module im_kernel
</Input>
EOT
  end

  it 'creates a config file for the mark log source' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_mark.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_mark.conf')
      .with_content(<<EOT)
<Input test_im_mark>
  Module im_mark
  Mark marky mark
  MarkInterval 50
</Input>
EOT
  end

  it 'creates a config file for the mseventlog log source' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_mseventlog.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_mseventlog.conf')
      .with_content(<<EOT)
<Input test_im_mseventlog>
  Module im_mseventlog
  UTF8 TRUE
</Input>
EOT
  end

  it 'creates a config file for the msvistalog log source' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_msvistalog.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_msvistalog.conf')
      .with_content(<<EOT)
<Input test_im_msvistalog>
  Module im_msvistalog
</Input>
EOT
  end

  it 'creates a config file for the null log source' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_null.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_null.conf')
      .with_content(<<EOT)
<Input test_im_null>
  Module im_null
</Input>
EOT
  end

  it 'creates a config file for the ssl log source' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_ssl.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_ssl.conf')
      .with_content(<<EOT)
<Input test_im_ssl>
  Module im_ssl
  OutputType Binary
  Host log.example.org
  Port 666
  CertFile %CERTDIR%/client-cert.pem
  CertKeyFile %CERTDIR%/client-key.pem
  CAFile %CERTDIR%/ca.pem
  AllowUntrusted FALSE
</Input>
EOT
  end

  it 'creates a config file for the tcp log source' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_tcp.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_tcp.conf')
      .with_content(<<EOT)
<Input test_im_tcp>
  Module im_tcp
  OutputType Binary
  Host log.example.org
  Port 667
</Input>
EOT
  end

  it 'creates a config file for the udp log source' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_udp.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_udp.conf')
      .with_content(<<EOT)
<Input test_im_tcp>
  Module im_udp
  OutputType Binary
  Host log.example.org
  Port 666
</Input>
EOT
  end

  it 'creates a config file for the uds log source' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_uds.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/ip_test_im_uds.conf')
      .with_content(<<EOT)
<Input test_im_uds>
  Module im_uds
  UDS /dev/log
</Input>
EOT
  end
end
