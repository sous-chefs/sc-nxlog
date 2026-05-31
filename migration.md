# Migration

## From Recipes And Attributes

The legacy `sc-nxlog::default`, `sc-nxlog::papertrail`, and `sc-nxlog::syslog`
recipes have been removed. Node attributes under `node['nxlog']` are no longer
read by this cookbook.

Use custom resources directly in wrapper cookbooks instead:

```ruby
nxlog_install 'default' do
  package_source 'https://packages.example.com/nxlog'
  package_checksum 'sha256-checksum'
end

nxlog_destination 'default_file' do
  file '/var/log/nxlog/default.log'
  default true
end

nxlog_source 'internal' do
  input_module 'im_internal'
  destination 'default_file'
end
```

## Papertrail

Replace `recipe[sc-nxlog::papertrail]` with:

```ruby
nxlog_papertrail_bundle 'default'

nxlog_papertrail 'papertrail' do
  host 'logs2'
  port 17992
  default true
end
```

## Syslog

Replace `recipe[sc-nxlog::syslog]` with:

```ruby
nxlog_syslog 'default' do
  destinations ['default_file']
end
```

## Attribute-Generated Resources

The old `node['nxlog']['sources']`, `node['nxlog']['destinations']`, and
`node['nxlog']['papertrails']` hashes are intentionally not supported. Declare
`nxlog_source`, `nxlog_destination`, and `nxlog_papertrail` resources directly so
resource properties are visible in the run context and can be tested with
ChefSpec.
