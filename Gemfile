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
