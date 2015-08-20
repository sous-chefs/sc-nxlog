require_relative 'spec_helper'

recipes = %w(test::papertrail_resources test::papertrail_resources_attrs)

recipes.each do |test_recipe|
  describe test_recipe do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(step_into:
                                 %w(nxlog_papertrail nxlog_destination))
        .converge(described_recipe)
    end

    it 'creates a papertrail destination for papertrail' do
      expect(chef_run).to create_nxlog_papertrail('my_papertrail')
    end

    it 'creates a log destination for papertrail' do
      expect(chef_run).to create_nxlog_destination('my_papertrail')
    end

    it 'creates a config file for the papertrail destination' do
      expect(chef_run).to create_template(
        '/etc/nxlog/nxlog.conf.d/10_op_my_papertrail.conf')

      expect(chef_run).to render_file(
        '/etc/nxlog/nxlog.conf.d/10_op_my_papertrail.conf')
        .with_content(<<EOT)
<Output my_papertrail>
  Module om_ssl
  Exec $Hostmame = hostname(); to_syslog_ietf();
  Host logs.papertrailapp.com
  Port 11111
  CAFile /etc/nxlog/certs/papertrail-bundle.pem
  AllowUntrusted FALSE
</Output>
EOT
    end

    it 'creates a config file for second the papertrail destination' do
      expect(chef_run).to create_template(
        '/etc/nxlog/nxlog.conf.d/10_op_my_papertrail_2.conf')

      expect(chef_run).to render_file(
        '/etc/nxlog/nxlog.conf.d/10_op_my_papertrail_2.conf')
        .with_content(<<EOT)
<Output my_papertrail_2>
  Module om_ssl
  Exec $Hostmame = hostname(); to_syslog_ietf();
  Host logs2.papertrailapp.com
  Port 11111
  CAFile /etc/nxlog/certs/papertrail-bundle.pem
  AllowUntrusted FALSE
</Output>
EOT
    end
  end
end
