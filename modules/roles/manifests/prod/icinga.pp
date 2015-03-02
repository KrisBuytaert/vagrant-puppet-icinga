class roles::prod::icinga {

  #  include profiles::baseline_linux
  include profile_icinga_server
  include profiles::icinga

}

