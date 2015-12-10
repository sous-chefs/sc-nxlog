require_relative 'spec_helper'

describe 'nxlog::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'installs nxlog' do
    expect(chef_run).to create_remote_file('nxlog').with_checksum(
      '5908a1efcfc87830eb03f3f08f00576aa98950e41ec11b96f9491e02f0d130c9'
    )
    expect(chef_run).to install_dpkg_package('nxlog')
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
