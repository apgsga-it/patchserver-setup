plan piper::jenkins_account_create (
  TargetSpec $targets
) {
  $targets.apply_prep
  $user = "jenkins"
  $maven_dir = "/home/${user}/.m2"
  $applyResult = apply($targets) {
      accounts::user { $user:
        ensure  => present,
        shell    => '/bin/bash',
        comment  => " ${user} User",
        # Default password , enrypted with openssl passwd -1 on target
        password => '$1$7vKrRq8U$K0dm4xWqhJ0M5tbvAmypl/',
      }
      ssh_keygen { $user: }
      file { $maven_dir:
        ensure => directory,
        owner => $user,
        group => $user,
        mode => '0644',
      }

  }

}
