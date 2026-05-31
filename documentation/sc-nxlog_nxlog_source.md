# nxlog_source

Writes an NXLog input block and route under `nxlog.conf.d`.

## Actions

* `:create`
* `:delete`

## Properties

`input_module` is required. The resource supports input modules including
`im_file`, `im_mark`, `im_internal`, `im_kernel`, `im_msvistalog`, `im_tcp`,
`im_udp`, `im_ssl`, and `im_uds`. Module-specific properties map directly to
NXLog directive names.

Use `destination` to route input to one or more destinations.
