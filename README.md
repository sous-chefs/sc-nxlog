# sc-nxlog

This cookbook provides custom resources for installing and configuring NXLog
Community Edition on Linux and Windows.

This release removes the legacy recipe and node attribute API. See
[migration.md](migration.md) for the breaking-change guide.

## Resources

* `nxlog_install`
* `nxlog_destination`
* `nxlog_source`
* `nxlog_papertrail_bundle`
* `nxlog_papertrail`
* `nxlog_syslog`

## Example

```ruby
nxlog_install 'default' do
  package_source 'https://packages.example.com/nxlog'
  package_checksum 'sha256-checksum'
end

nxlog_destination 'local_file' do
  file '/var/log/nxlog/local.log'
  default true
end

nxlog_source 'internal' do
  input_module 'im_internal'
  destination 'local_file'
end
```

NXLog CE packages are not published through public APT/YUM repositories. Review
[LIMITATIONS.md](LIMITATIONS.md) before relying on the default package artifact
names or mirror URL.
