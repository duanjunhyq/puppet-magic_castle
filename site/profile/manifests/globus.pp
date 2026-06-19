#class profile::globus {
#  package { 'wget':
#    ensure => installed,
#  }

#  $public_ip = lookup('terraform.self.public_ip')
#  class { 'globus':
#    display_name  => $globus::display_name,
#    client_id     => $globus::client_id,
#    client_secret => $globus::client_secret,
#    contact_email => $globus::contact_email,
#    ip_address    => $public_ip,
#    organization  => $globus::organization,
#    owner         => $globus::owner,
#    require       => Package['wget'],
#  }
#}
class profile::globus {
  package { 'wget':
    ensure => installed,
  }

  $public_ip = lookup('terraform.self.public_ip')

  $display_name   = lookup('globus::display_name')
  $client_id      = lookup('globus::client_id')
  $client_secret  = lookup('globus::client_secret')
  $contact_email  = lookup('globus::contact_email')
  $organization   = lookup('globus::organization')
  $owner          = lookup('globus::owner')

  class { 'globus':
    display_name  => $display_name,
    client_id     => $client_id,
    client_secret => $client_secret,
    contact_email => $contact_email,
    ip_address    => $public_ip,
    organization  => $organization,
    owner         => $owner,
    require       => Package['wget'],
  }
}
