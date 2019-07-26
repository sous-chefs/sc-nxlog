name             'sc-nxlog'
version          '0.9.0'

description      'Installs and configures NXLog_ce on Linux or Windows'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))

chef_version '>= 12.1' if respond_to?(:chef_version)

issues_url       'https://github.com/sous-chefs/sc-nxlog/issues'
source_url       'https://github.com/sous-chefs/sc-nxlog/'

supports         'ubuntu', '>= 14.04'
supports         'debian', '>= 8.0'
supports         'redhat', '>= 6.0'
supports         'centos', '>= 6.0'
supports         'windows'

maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
