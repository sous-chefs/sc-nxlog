require 'serverspec'
require 'socket'

# there may be a better way to detect Windows!
if ENV['APPDATA']
  set :backend, :cmd
  set :os, family: 'windows'
  junit_path = 'c:\.junit'
else
  set :backend, :exec
  junit_path = '/.junit'
end

# teamcity-specific: write junit xml output from tests
# (directory is only mounted for tc builds)
if File.exist? "#{junit_path}/git-keep"
  RSpec.configure do |c|
    c.output_stream = File.open(
      "#{File.join(junit_path, Socket.gethostname)}.xml", 'w')
    c.formatter = 'RspecJunitFormatter'
  end
end
