plan piper::piper_service_account_create (
  TargetSpec $targets
) {
  $targets.apply_prep
  $applyResult = apply($targets) {
      $user = "${lookup('piper::service::target::user')}"
      $ssh_dir = "/home/${user}/.ssh"
      accounts::user { $user:
        ensure  => present,
        shell    => '/bin/bash',
        comment  => " ${user} User",
        # Default password , enrypted with openssl passwd -1 on target
        password => "${lookup('piper::service::target::pw')}",
      }
      ssh::config_entry { $user:
        host  => '*',
        ensure => present,
        path   => "${ssh_dir}/config",
        owner  => $user,
        group  => $user,
        lines => [
        '  NoHostAuthenticationForLocalhost yes',
        ],
      }

  }

}
