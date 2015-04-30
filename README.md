# NXLog Cookbook 

[![Build Status](https://gemnasium.com/widgit-cookbooks/nxlog.svg)](https://gemnasium.com/widgit-cookbooks/nxlog)
[![Dependency Status](https://secure.travis-ci.org/widgit-cookbooks/nxlog.svg?branch=master)](https://travis-ci.org/widgit-cookbooks/nxlog)
[![Code Climate](https://codeclimate.com/github/widgit-cookbooks/nxlog.svg?branch=master)](https://codeclimate.com/github/widgit-cookbooks/nxlog)

This cookbook sets up NXLog on a Windows or Linux host.

NXLog is a flexible log-management service that is able to read and write
logs in a variety of formats, and to numerous places.

This is a good solution if you want to gather the logs from various systems
or processes into a central location such as a syslog daemon or papertrail.
It can be used to merge log files, the kernel, syslog or the Windows event log
all into one place. It has powerful routing and conversion capabilities so that
logs can be written into different formats and sent to multiple places.

The cookbook provides LWRPs for log sources and destinations, and makes it easy
to set up routes between them.

Additionally, this cookbook includes a papertrail LWRP to simplify the
publishing of logs to that service.

## Supported Platforms

 * Windows Server 2008r2-2012r2
 * Ubuntu/Debian Linux
 * RHEL/Centos Linux
 
### Usage

Include `nxlog` in your node's `run_list`:

    {
        "run_list": [
            "recipe[nxlog::default]"
        ]
    }

If you wish to enable Papertrail support, also include the papertrail recipe:

    {
        "run_list": [
             "recipe[nxlog::default]"
             "recipe[nxlog::papertrail]"
        ]
    }

This should be enough to get nxlog installed and running. However, it won't do
much on its own. In order for it to do something useful you need to configure
log sources and destinations.

A simple example recipe to log Windows events to a file:

    include_recipe 'nxlog::default'
    
    nxlog_destination 'windows_events_file' do
      file 'c:/windows/temp/events.log'
    end
    
    nxlog_source 'event_log' do
      input_module 'im_msvistalog'
      destination 'windows_events_file'
    end

A more advanced recipe to log multiple sources to papertrail might look like:

    include_recipe 'nxlog::default'
    include_recipe 'nxlog::papertrail'
    
    nxlog_papertrail 'papertrail' do
      default true   # use this as the default destination for all inputs
      host 'logs2'
      port 11111
    end
    
    nxlog_source 'apache_errors' do
      file '/var/log/apache2/errors.log'
    end
    
    nxlog_source 'apache_access' do
      file '/var/log/apache2/access.log'
    end



## Attributes

The attributes mostly concern default config locations and will most likely work
for your platform without modification. 

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['nxlog']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## License and Authors

Author:: Simon Detheridge, Widgit Software (<simon@widgit.com>)
License:: Apache Version 2.0
