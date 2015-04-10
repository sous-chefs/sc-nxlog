require_relative 'spec_helper'

describe 'nxlog_ce::test_input_resources' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['nxlog_ce_source'])
      .converge(described_recipe)
  end

  it 'creates a log source for a file' do
    expect(chef_run).to create_nxlog_ce_source('test_im_file')
  end
end
