class roles::prod::icinga {

  include profiles::baseline_linux
  include profiles::icinga_server

}

