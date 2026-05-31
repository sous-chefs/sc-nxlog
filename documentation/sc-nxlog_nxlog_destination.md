# nxlog_destination

Writes an NXLog output block under `nxlog.conf.d`.

## Actions

* `:create`
* `:delete`

## Properties

The resource supports NXLog output modules such as `om_file`, `om_tcp`,
`om_udp`, `om_ssl`, `om_http`, `om_exec`, `om_dbi`, `om_blocker`, `om_null`, and
`om_uds`. Module-specific properties map directly to NXLog directive names.

Set `default true` to include this destination in the generated
`DEFAULT_OUTPUTS` list.
