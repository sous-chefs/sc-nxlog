name             'nxlog'
version          '0.5.0'

description      'Installs and configures NXLog_ce on Linux or Windows'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))

issues_url       'http://github.com/widgit-cookbooks/nxlog/issues'
source_url       'http://github.com/widgit-cookbooks/nxlog/'

provides         'nxlog::default'
provides         'nxlog::papertrail'
provides         'service[nxlog]'

supports         'ubuntu', '>= 12.04'
supports         'debian', '>= 6.0'
supports         'redhat', '>= 6.0'
supports         'centos', '>= 6.0'
supports         'windows'

recipe           'nxlog::default'
recipe           'nxlog::papertrail'

maintainer       'Simon Detheridge'
maintainer_email 'simon@widgit.com'
license          'Apache v2.0'
