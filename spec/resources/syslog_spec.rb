# frozen_string_literal: true

require 'spec_helper'

describe 'test::syslog' do
  subject(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04', step_into: %w(nxlog_syslog nxlog_source)).converge(described_recipe)
  end

  it 'links /dev/log to the NXLog socket' do
    expect(chef_run).to create_link('/dev/log').with(to: '/var/run/nxlog/devlog')
  end

  it 'renders the syslog source' do
    expect(chef_run).to create_template('/etc/nxlog/nxlog.conf.d/20_ip_syslog.conf')
  end
end
