# frozen_string_literal: true

require 'spec_helper'

describe 'test::default' do
  subject(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04', step_into: ['nxlog_source']).converge(described_recipe)
  end

  it 'renders source snippets' do
    expect(chef_run).to create_template('/etc/nxlog/nxlog.conf.d/20_ip_mark.conf')
      .with(source: 'resources/source.conf.erb')
  end
end
