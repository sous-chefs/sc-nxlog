source 'https://rubygems.org'

gem 'berkshelf'

group :integration do
  gem 'serverspec'
  gem 'windows_chef_zero'
  gem 'winrm-transport'
  gem 'test-kitchen', git: 'https://github.com/test-kitchen/test-kitchen',
                      tag: 'v1.4.0.rc.1'
  gem 'kitchen-vagrant', git: 'https://github.com/test-kitchen/kitchen-vagrant',
                         tag: 'v0.17.0.rc.1'
end

group :development, :test do
  gem 'rspec_junit_formatter'
  gem 'chefspec'
  gem 'foodcritic'
  gem 'rubocop'
  gem 'rake'
end

group :development do
  gem 'pry', '~> 0.9.0'
  gem 'travis', '~> 1.7.5'
end
