require_relative 'spec_helper'

describe 'nxlog_ce::test_default_resources' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into:
                               %w(nxlog_ce_source nxlog_ce_destination))
      .converge(described_recipe)
  end

  it 'creates a mark log source' do
    expect(chef_run).to create_nxlog_ce_source('test_im_mark_1')
  end

  it 'creates a file log destination' do
    expect(chef_run).to create_nxlog_ce_destination('test_om_file_1')
  end

  it 'creates a config file for a source with no destination specified' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/20_ip_test_im_mark_1.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/20_ip_test_im_mark_1.conf')
      .with_content(<<EOT)
define DEFAULT_OUTPUTS
include /conf/nxlog.conf.d/op_*.default

<Input test_im_mark_1>
  Module im_mark
  MarkInterval 1
</Input>

<Route r_test_im_mark_1>
  Path test_im_mark_1 => %DEFAULT_OUTPUTS%
</Route>
EOT
  end

  it 'creates a config file for a source with one destination specified' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/20_ip_test_im_mark_2.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/20_ip_test_im_mark_2.conf')
      .with_content(<<EOT)
define DEFAULT_OUTPUTS
include /conf/nxlog.conf.d/op_*.default

<Input test_im_mark_2>
  Module im_mark
  MarkInterval 1
</Input>

<Route r_test_im_mark_2>
  Path test_im_mark_2 => foo
</Route>
EOT
  end

  it 'creates a config file for a source with several destinations specified' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/20_ip_test_im_mark_3.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/20_ip_test_im_mark_3.conf')
      .with_content(<<EOT)
define DEFAULT_OUTPUTS
include /conf/nxlog.conf.d/op_*.default

<Input test_im_mark_3>
  Module im_mark
  MarkInterval 1
</Input>

<Route r_test_im_mark_3>
  Path test_im_mark_3 => foo, bar
</Route>
EOT
  end

  it 'creates a config file for a source with default + other destinations' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/20_ip_test_im_mark_4.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/20_ip_test_im_mark_4.conf')
      .with_content(<<EOT)
define DEFAULT_OUTPUTS
include /conf/nxlog.conf.d/op_*.default

<Input test_im_mark_4>
  Module im_mark
  MarkInterval 1
</Input>

<Route r_test_im_mark_4>
  Path test_im_mark_4 => foo, bar, %DEFAULT_OUTPUTS%
</Route>
EOT
  end

  it 'creates config files for the log destinations' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/10_op_test_om_file_1.conf')
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/10_op_test_om_file_2.conf')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/10_op_test_om_file_1.conf')
      .with_content(<<EOT)
<Output test_om_file_1>
  Module om_file
  File "/var/log/mark.log"
</Output>
EOT

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/10_op_test_om_file_2.conf')
      .with_content(<<EOT)
<Output test_om_file_2>
  Module om_file
  File "/var/log/mark2.log"
</Output>
EOT
  end

  it 'creates a default output definition for the first log file' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/op_test_om_file_1.default')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/op_test_om_file_1.default')
      .with_content(<<EOT)
define DEFAULT_OUTPUTS %DEFAULT_OUTPUTS%, test_om_file_1
EOT
  end

  it 'creates a default output definition for the second log file' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/op_test_om_file_2.default')

    expect(chef_run).to render_file(
      '/etc/nxlog/nxlog.conf.d/op_test_om_file_2.default')
      .with_content(<<EOT)
define DEFAULT_OUTPUTS %DEFAULT_OUTPUTS%, test_om_file_2
EOT
  end

  it 'does not create a default output definition for the third log file' do
    expect(chef_run).to create_template(
      '/etc/nxlog/nxlog.conf.d/20_ip_test_im_mark_3.conf')

    expect(chef_run).not_to create_template(
      '/etc/nxlog/nxlog.conf.d/op_test_om_file_3.default')
  end
end
