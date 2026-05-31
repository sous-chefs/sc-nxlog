# frozen_string_literal: true

name             'sc-nxlog'
version          '1.0.9'
description      'Provides NXLog install and configuration custom resources'
issues_url       'https://github.com/sous-chefs/sc-nxlog/issues'
source_url       'https://github.com/sous-chefs/sc-nxlog'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
chef_version      '>= 16.0'

supports 'almalinux', '>= 9.0'
supports 'centos_stream', '>= 9.0'
supports 'debian', '>= 11.0'
supports 'redhat', '>= 9.0'
supports 'rocky', '>= 9.0'
supports 'ubuntu', '>= 22.04'
supports 'windows'
