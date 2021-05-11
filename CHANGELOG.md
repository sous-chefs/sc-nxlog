# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

- resolved cookstyle error: resources/destination.rb:1:1 refactor: `Chef/Deprecations/ResourceWithoutUnifiedTrue`
- resolved cookstyle error: resources/papertrail.rb:1:1 refactor: `Chef/Deprecations/ResourceWithoutUnifiedTrue`
- resolved cookstyle error: resources/source.rb:1:1 refactor: `Chef/Deprecations/ResourceWithoutUnifiedTrue`

## [0.10.0]

### Added

### Changed

- Removed unnecessary default values from the source and destination resources.
- Removed unnecessary name property from the papertrail resource
- Use true/false as types in resource attributes
- Migrated to Github Actions
- resolved cookstyle error: attributes/default.rb:46:3 refactor: `ChefCorrectness/ChefApplicationFatal`
- resolved cookstyle error: recipes/default.rb:32:3 refactor: `ChefCorrectness/ChefApplicationFatal`
- resolved cookstyle error: recipes/syslog.rb:23:3 refactor: `ChefCorrectness/ChefApplicationFatal`
- resolved cookstyle error: recipes/syslog.rb:30:3 refactor: `ChefStyle/NegatingOnlyIf`
- resolved cookstyle error: test/integration/attribute_resources/attribute_resources_spec.rb:20:3 refactor: `ChefCorrectness/ChefApplicationFatal`
- resolved cookstyle error: test/integration/lwrp_resources/lwrp_resources_spec.rb:20:3 refactor: `ChefCorrectness/ChefApplicationFatal`
- resolved cookstyle error: test/integration/papertrail/papertrail.rb:14:3 refactor: `ChefCorrectness/ChefApplicationFatal`
- resolved cookstyle error: test/integration/syslog/syslog_spec.rb:17:3 refactor: `ChefCorrectness/ChefApplicationFatal`

### Deprecated

### Removed

- Removed unnecessary actions method usage in the resources

## [0.9.0] - 2018-09-19

### Added

### Changed

- Raised minimum Ubuntu version from 12.04 to 14.04
- Raised minimum Debian version from 6.0 to 8.0
- Migrated to Sous-Chefs
- Changed cookbook name from `nxlog` to `sc-nxlog`

### Deprecated

### Removed

## [0.8.7] - 2015-12-22

### Added

### Changed

- Prevent installation of package config from .deb packages

### Deprecated

### Remove

## [0.8.6]

- Update nokogiri gem due to security alert

## [0.8.5]

- Point nxlog base URL at mirror, as nxlog keep taking down old versions and breaking the cookbook
- Add cookbook attribute to allow different base URLs

## [0.8.4]

- Nxlog version bump
- Fix integration tests for Chef 12.5

## [0.8.3]

- Added json extension module

## [0.8.2]

- Added checksum validation to nxlog remote_file packages

## [0.8.1]

- Remove input_type equal_to validation

## [0.8.0]

- Add syslog recipe

## [0.7.2]

- Add support for the FlowControl directive in input modules

## [0.7.1]

- Update documentation to link to github page, as it looks better than on the supermarket

## [0.7.0]

- Add support for creating log resources from node attributes

## [0.6.0]

- Fix issue with LWRPs not working in other recipes

## [0.5.0]

- Initial release of nxlog cookbook
