plan piper::piper_service_account_create (
  TargetSpec $targets
) {
  $targets.apply_prep
  $user = "apg-patch-service-server"
  $ssh_dir = "/home/${user}/.ssh"
  $applyResult = apply($targets) {
      accounts::user { $user:
        ensure  => present,
        shell    => '/bin/bash',
        comment  => " ${user} User",
        # Default password , enrypted with openssl passwd -1 on target
        password => '$1$7odv7BNP$yxQKgUXRd2MIFY5Clc7lf1',

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
