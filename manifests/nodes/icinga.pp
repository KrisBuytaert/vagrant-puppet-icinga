node /icinga/ {

  include ::roles::prod::icinga

  
  file { '/etc/sudoers.d/10_vagrant':
    content          => 'Defaults:vagrant  !requiretty
    vagrant ALL=(ALL) NOPASSWD: ALL',
    group        => '0',
    mode       => '0644',
    owner  => '0',
  }

}
