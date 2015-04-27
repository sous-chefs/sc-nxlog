require_relative 'spec_helper'

describe 'nxlog::papertrail' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'creates the certificates directory' do
    expect(chef_run).to create_directory('/etc/nxlog/certs')
  end

  it 'creates downloads the papertrail certificate bundle' do
    expect(chef_run).to create_remote_file(
      '/etc/nxlog/certs/papertrail-bundle.pem')
  end
end
