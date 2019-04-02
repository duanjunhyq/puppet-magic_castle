class profile::cvmfs::client (String $squid_server = "mgmt01") {
  package { 'cvmfs-repo':
    name     => 'cvmfs-release-2-6.noarch',
    provider => 'rpm',
    ensure   => 'installed',
    source   => 'https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm'
  }

  package { 'cc-cvmfs-repo':
    name     => 'computecanada-release-1.0-1.noarch',
    provider => 'rpm',
    ensure   => 'installed',
    source   => 'https://package.computecanada.ca/yum/cc-cvmfs-public/Packages/computecanada-release-1.0-1.noarch.rpm'
  }

  package { ['cvmfs', 'cvmfs-config-computecanada', 'cvmfs-config-default', 'cvmfs-auto-setup']:
    ensure => 'installed',
    require => [Package['cvmfs-repo'], Package['cc-cvmfs-repo']]
  }

  file { '/etc/cvmfs/default.local':
    ensure  => 'present',
    content => epp('profile/cvmfs/default.local', { 'squid_server' => $squid_server }),
    require => Package['cvmfs']
  }

  file { '/etc/profile.d/z-00-computecanada.sh':
    ensure  => 'present',
    source  => 'puppet:///modules/profile/cvmfs/z-00-computecanada.sh',
    require => File['/etc/cvmfs/default.local']
  }

  service { 'autofs':
    ensure  => running,
    enable  => true,
    require => File['/etc/cvmfs/default.local']
  }

  # Fix issue with BASH_ENV, SSH and lmod where
  # ssh client would get a "Permission denied" when
  # trying to connect to a server. The errors
  # results from the SELinux context type of
  # /cvmfs/soft.computecanada.ca/nix/var/nix/profiles/16.09/lmod/lmod/init/bash
  # To be authorized in the ssh context, it would need
  # to be a bin_t type, but it is a fusefs_t and since
  # CVMFS is a read-only filesystem, the context cannot be changed.
  # 'use_fusefs_home_dirs' policy fix that issue.
  selinux::boolean { 'use_fusefs_home_dirs': }

}
