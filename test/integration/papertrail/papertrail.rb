describe service('nxlog') do
  it { should be_enabled }
  it { should be_running }
end

case os[:family]
when 'debian', 'ubuntu'
  conf_dir = '/etc/nxlog'
when 'redhat'
  conf_dir = '/etc'
when 'windows'
  conf_dir = 'c:/Program Files (x86)/nxlog/conf'
else
  raise('Attempted to install on an unsupported platform')
end

describe file("#{conf_dir}/certs/papertrail-bundle.pem") do
  it { should be_file }
end
