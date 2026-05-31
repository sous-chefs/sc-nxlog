# nxlog_papertrail

Creates an SSL destination for Papertrail.

## Actions

* `:create`
* `:delete`

## Properties

* `host` - Papertrail host prefix. Defaults to `logs`.
* `port` - Papertrail port. Required.
* `default` - Whether this destination joins `DEFAULT_OUTPUTS`.
* `conf_dir` - NXLog configuration directory.
