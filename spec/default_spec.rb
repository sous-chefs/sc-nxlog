require_relative 'spec_helper'

describe 'nxlog_ce::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'installs nxlog_ce' do
    expect(chef_run).to create_remote_file('nxlog_ce')
    expect(chef_run).to install_dpkg_package('nxlog_ce')
    expect(chef_run).to enable_service('nxlog')
  end

  it 'creates a config file' do
    expect(chef_run).to render_file('/etc/nxlog/nxlog.conf')
      .with_content(/User *nxlog/)
    expect(chef_run).not_to render_file('/etc/nxlog/nxlog.conf')
      .with_content(/SpoolDir/)

    expect(chef_run.service('nxlog')).to(
      subscribe_to('template[/etc/nxlog/nxlog.conf]'))
  end

  it 'creates a config directory' do
    expect(chef_run).to create_directory('/etc/nxlog/nxlog.conf.d')
  end
end

describe 'nxlog_ce::test_resources' do
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
end
