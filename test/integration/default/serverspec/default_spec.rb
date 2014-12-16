require_relative 'spec_helper'

describe service('nxlog') do
  it { should be_enabled }
  it { should be_running }
end
