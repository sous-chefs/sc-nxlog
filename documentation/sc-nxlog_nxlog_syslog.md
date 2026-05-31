# nxlog_syslog

Configures NXLog as the local syslog receiver on Linux.

## Actions

* `:create`
* `:delete`

## Properties

* `logger_disable` - Existing logger service to stop and disable. Defaults to `rsyslog`.
* `destinations` - Destination or destinations for syslog input.
* `socket_path` - Unix socket path used by NXLog.
* `conf_dir` - NXLog configuration directory.
