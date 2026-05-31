# frozen_string_literal: true

require 'spec_helper'

describe 'test::default' do
  subject(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04', step_into: ['nxlog_destination']).converge(described_recipe)
  end

  it 'renders destination snippets' do
    expect(chef_run).to create_template('/etc/nxlog/nxlog.conf.d/10_op_test.conf')
      .with(source: 'resources/destination.conf.erb')
  end

  it 'renders default destination marker files' do
    expect(chef_run).to create_template('/etc/nxlog/nxlog.conf.d/op_test_2.default')
      .with(source: 'resources/destination.default.erb')
  end
end
