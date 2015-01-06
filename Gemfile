source 'https://rubygems.org'

gem 'berkshelf'

# Uncomment these lines if you want to live on the Edge:
#
# group :development do
#   gem "berkshelf", github: "berkshelf/berkshelf"
#   gem "vagrant", github: "mitchellh/vagrant", tag: "v1.6.3"
# end
#
# group :plugins do
#   gem "vagrant-berkshelf", github: "berkshelf/vagrant-berkshelf"
#   gem "vagrant-omnibus", github: "schisamo/vagrant-omnibus"
# end

group :integration do
  gem 'serverspec'
  gem 'windows_chef_zero'
  gem 'test-kitchen', git: 'https://github.com/mwrock/test-kitchen', branch: 'zip'
  gem 'kitchen-vagrant', git: 'https://github.com/jdmundrawala/kitchen-vagrant', branch: 'Transport'
end

group :development do
  gem 'chefspec'
  gem 'strainer'
  gem 'foodcritic'
  gem 'rubocop'
end
