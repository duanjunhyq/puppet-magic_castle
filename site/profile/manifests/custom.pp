class profile::custom {
  package { 's3fs-fuse':
    ensure => installed,
  }

  $access_key_id = lookup('profile::s3fs::access_key_id')
  $secret_access_key = lookup('profile::s3fs::secret_access_key')

  file { '/etc/passwd-s3fs':
    ensure => present,
    content => "${access_key_id}:$secret_access_key",
    mode    => '0600',
  }
  file { '/mnt/cidgoh-object-storage':
    ensure => directory,
    mode   => '0777',
  }
  

  file_line { 'add_object_storage':
    path   => '/etc/fstab',
    line   => 'cidgohshare /mnt/cidgoh-object-storage fuse.s3fs _netdev,use_path_request_style,umask=0000,allow_other,passwd_file=/etc/passwd-s3fs,url=https://object-arbutus.cloud.computecanada.ca/ 0 0',
    ensure => present,
    notify => Exec['mount_fstab'],
}

  exec { 'mount_fstab':
    command     => '/bin/mount -a',
    refreshonly => true,
  }


  
  package { 'acl':
    ensure => 'present',
  }





}
