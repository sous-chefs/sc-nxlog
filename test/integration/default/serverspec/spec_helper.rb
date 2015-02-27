require 'serverspec'

# there may be a better way to detect Windows!
if ENV['APPDATA']
  set :backend, :cmd
  set :os, family: 'windows'
else
  set :backend, :exec
end
