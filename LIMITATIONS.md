# Limitations

## Package Availability

NXLog Community Edition provides downloadable packages, but not public APT or
YUM repositories. This cookbook therefore installs from a package mirror URL
and exposes `package_source`, `package_name`, and `package_checksum` properties
on `nxlog_install` so users can point at an internal mirror.

### APT (Debian/Ubuntu)

* Ubuntu 22.04: NXLog CE 3.2.2329 is listed as `nxlog-ce_3.2.2329_ubuntu22_amd64.deb`.
* Debian 11: NXLog CE 3.2.2329 is listed as `nxlog-ce_3.2.2329_debian11_amd64.deb`.
* Ubuntu 24.04 and Debian 12 are listed in current NXLog platform support, but
  were not listed on the current NXLog CE downloads page checked during this
  migration.

### DNF/YUM (RHEL family)

* RHEL 9 compatible systems: NXLog CE 3.2.2329 is listed as
  `nxlog-ce-3.2.2329_rhel9.x86_64.rpm`.

### Windows

* Windows x86-64: NXLog CE 3.2.2329 is listed as `nxlog-ce-3.2.2329.msi`.

## Architecture Limitations

The public NXLog CE downloads page listed x86-64 package artifacts for the
platforms above. NXLog product documentation lists additional architectures for
some current operating systems, but matching CE download artifacts were not
listed on the downloads page.

## Source/Compiled Installation

This cookbook does not build NXLog from source. Users who need unlisted
platforms or architectures should mirror a vendor-provided package and override
`package_name`, `package_source`, and `package_checksum`.

## Known Issues

The historic cookbook defaulted to a third-party mirror because the NXLog site
does not provide unattended repository metadata. That behavior is preserved as a
property default for compatibility, but production users should provide their
own mirror and checksum.
