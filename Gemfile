source 'https://rubygems.org'

gem 'berkshelf'

group :integration do
  gem 'serverspec'
  gem 'windows_chef_zero'
  gem 'test-kitchen', git: 'https://github.com/afiune/test-kitchen',
                      branch: 'Transport'
  gem 'kitchen-vagrant', git: 'https://github.com/afiune/kitchen-vagrant',
                         branch: 'Transport'
end

group :development do
  gem 'chefspec'
  gem 'strainer'
  gem 'foodcritic'
  gem 'rubocop'
end
