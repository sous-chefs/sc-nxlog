# frozen_string_literal: true

require 'spec_helper'

describe 'test::papertrail' do
  subject(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '22.04',
      step_into: %w(nxlog_papertrail_bundle nxlog_papertrail nxlog_destination)
    ).converge(described_recipe)
  end

  it 'downloads the Papertrail bundle' do
    expect(chef_run).to create_remote_file('/etc/nxlog/certs/papertrail-bundle.pem')
      .with(source: 'file:///tmp/papertrail-bundle.pem')
  end

  it 'renders the Papertrail destination' do
    expect(chef_run).to create_template('/etc/nxlog/nxlog.conf.d/10_op_papertrail.conf')
  end
end
