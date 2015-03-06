source 'https://rubygems.org'

gem 'berkshelf'

group :integration do
  gem 'serverspec'
  gem 'windows_chef_zero'
  gem 'test-kitchen', git: 'https://github.com/nvmlabs/test-kitchen',
                      branch: 'windows-guest-support'
  gem 'kitchen-vagrant', git: 'https://github.com/test-kitchen/kitchen-vagrant',
                         branch: 'windows-guest-support'
end

group :development, :test do
  gem 'chefspec'
  gem 'strainer'
  gem 'foodcritic'
  gem 'rubocop'
  gem 'rake'
end

group :development do
  gem 'pry', '~> 0.9.0'
  gem 'travis', '~> 1.7.5'
end
