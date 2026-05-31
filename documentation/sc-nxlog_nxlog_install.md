# nxlog_install

Installs NXLog from a mirrored package artifact and writes the main
`nxlog.conf` file.

## Actions

* `:install`
* `:remove`

## Properties

* `version` - NXLog CE version. Defaults to `3.2.2329`.
* `package_source` - Base URL for package downloads.
* `package_name` - Package artifact name. Defaults from platform family.
* `package_checksum` - Optional package checksum.
* `install_package` - Set to `false` when a wrapper manages package install.
* `manage_service` - Enable and start the `nxlog` service.
* `conf_dir`, `root_dir`, `log_file`, `log_level`, `user`, `group` - Runtime configuration.
