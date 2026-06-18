class profile::mkhomedir {
  # Ensure the line is present in /etc/pam.d/sshd
  file_line { 'pam_mkhomedir_sshd':
    path  => '/etc/pam.d/sshd',
    line  => 'session    required     pam_mkhomedir.so skel=/etc/skel/ umask=0022',
    after => 'session    required     pam_selinux.so open env_params',
    match => '^session\s+required\s+pam_mkhomedir\.so',
    notify => Service['sshd'],
  }
}
