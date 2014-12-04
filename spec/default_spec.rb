require_relative 'spec_helper'

describe 'nxlog-ce::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'installs nxlog-ce' do
    expect(chef_run).to create_remote_file('nxlog-ce')
    expect(chef_run).to install_dpkg_package('nxlog-ce')
  end
end