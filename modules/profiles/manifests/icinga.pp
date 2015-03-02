  class profiles::icinga {


    Exec {
      path => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    }
    # After the intallation of the icinga server this stanza needs to move to the icinga monitoring profiles
    # that should be included in all nodes by default

    if $::hostname =~ /icinga/ {
      $is_icinga_server  = true
    }
    else 
    {
      $is_icinga_server  = false
    }


    class{'::icinga':
      server                => $is_icinga_server,
      nrpe_allowed_hosts    => hiera('nrpe_allowed_hosts'),
      plugins               => hiera('icinga_plugins'),
      collect_ipaddress     => hiera('icinga_collect_ipaddress'),
      parents               => $icinga_parents,
      hostgroups            => hiera('icinga_hostgroups'),
      notification_period   => hiera('icinga_notification_period'),
      notifications_enabled => hiera('icinga_notifications_enabled'),
      service_perfdata_file => '/tmp/service-perfdata',
      process_service_perfdata_file => 'process-service-perfdata-to-graphite-file',

    }

    class{'::icinga::plugins::checkalldisks':
      check_warning  => hiera('icinga_plugins_checkalldisks_warning'),
      check_critical => hiera('icinga_plugins_checkalldisks_critical'),
    }

    class{'::icinga::plugins::checkmailq':
      mailserver_type => hiera('icinga_checkmailq_mta_type'),
      check_warning   => hiera('icinga_checkmailq_warning', 5),
      check_critical  => hiera('icinga_checkmailq_critical', 10),
    }

    #    class{'::icinga::plugins::checkntp':
    #  ntp_server => hiera('ntp_server'),
    #}

    firewall{'010 nrpe':
      dport  => '5666',
      source => hiera('nrpe_allowed_hosts'),
      action => 'accept',
      tag    => 'firewall',
    }


    include ::epel

    yumrepo { 'inuits':
      baseurl  => 'http://repo.inuits.eu/pulp/inuits/$releasever/$basearch',
      descr    => 'CentOS-$releasever - Inuits',
      enabled  => '1',
      gpgcheck => '0',
    }

    sudo::conf{'nrpe':
      content => "Defaults:nagios !requiretty\nnagios ALL=(ALL) NOPASSWD:/usr/lib/nagios/plugins/check_disk,/usr/lib64/nagios/plugins/check_disk,/usr/lib/nagios/plugins/check_mailq,/usr/lib64/nagios/plugins/check_mailq,/usr/lib64/nagios/plugins/check_puppetmaster.sh\n",
    }


}

