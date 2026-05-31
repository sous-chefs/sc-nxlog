# frozen_string_literal: true

require 'spec_helper'

describe 'test::default' do
  subject(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04', step_into: ['nxlog_install']).converge(described_recipe)
  end

  it 'creates the NXLog configuration directory' do
    expect(chef_run).to create_directory('/etc/nxlog')
    expect(chef_run).to create_directory('/etc/nxlog/nxlog.conf.d')
  end

  it 'renders the main NXLog configuration' do
    expect(chef_run).to create_template('/etc/nxlog/nxlog.conf')
      .with(source: 'nxlog.conf.erb')
  end

  it 'does not install the package when disabled by the wrapper' do
    expect(chef_run).to_not create_remote_file('nxlog package')
    expect(chef_run).to_not install_dpkg_package('nxlog')
  end
end
