  class profile_icinga_server {


    # no exported resources so no collection so manuall add host


    class {'icinga::plugins::perfdatatographite':
      carbon_host => 'graphite-01',
      carbon_port => '2003',
      }

    nagios_host{'icinga':
      host_name                => 'icinga',
      address            => '127.0.0.1',
      hostgroups   => 'default',
      target => '/etc/icinga/objects/hosts/icinga.cfg',
    }



    Exec {

      path => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    }


    #  Setting up httpd etc.

    firewall{'010 http 80':
      dport  => '80',
      action => 'accept',
    }

    # Refactor to use upstream apache
    #
    #
    #

     package { 'httpd':
      ensure => latest,
     }


     service { 'httpd':
       ensure     => running,
       enable     => true,
       hasrestart => true,
       hasstatus  => true,
       require    => Package['httpd'],
     }





    Icinga::User {
      ensure                        => present,
      hash                          => true,
      can_submit_commands           => '1',
      contactgroups                 => 'admins',
      host_notifications_enabled    => '0',
      service_notifications_enabled => '0',
    }

    icinga::user{'sdog':
      email                         => 'sdog@inuits.eu',
      pager                         => 'sdog@inuits.eu',
      password                      => 'wanawer',
      host_notification_commands    => 'notify-host-by-email',
      service_notification_commands => 'notify-service-by-email',
      host_notifications_enabled    => '1',
      service_notifications_enabled => '1',
    }


    icinga::user{'intelliplan':
      email                         => 'developer@intelliplan.se',
      pager                         => 'developer@intelliplan.se',
      password                      => 'nope',
      host_notification_commands    => 'notify-host-by-email',
      service_notification_commands => 'notify-service-by-email',
      host_notifications_enabled    => '1',
      service_notifications_enabled => '1',
                                                     }




    Nagios_Hostgroup {
      notify => Service['icinga'],
      target => "${::icinga::targetdir}/hostgroups.cfg",
    }

    nagios_hostgroup{'prod':
      hostgroup_name => 'prod',
    }

    nagios_hostgroup{'internal':
      hostgroup_name => 'internal',
    }


    Nagios_host{
      ensure             => present,
      contact_groups     => 'production',
      max_check_attempts => '4',
      check_command      => 'check-host-alive',
      use                => 'linux-server',
      action_url         => '/pnp4nagios/graph?host=$HOSTNAME$',
    }


    icinga::group {'prod':
      alias   => 'Production Engineers',
      members => 'sdog',
    }

    file { '/etc/icinga/passwd':
      ensure => 'link',
      group  => '0',
      mode   => '0777',
      owner  => '0',
      target => 'htpasswd.users',
    }





  }

