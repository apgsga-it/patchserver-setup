plan piper::jenkins_account_create (
  TargetSpec $targets
) {
  $targets.apply_prep
  $applyResult = apply($targets) {
      $user = "${lookup('jenkins::target::user')}"
      $ssh_dir = "/home/${user}/.ssh"
      $maven_dir = "/home/${user}/.m2"
      accounts::user { $user:
        ensure  => present,
        shell    => '/bin/bash',
        comment  => " ${user} User",
        password => "${lookup('jenkins::target::pw')}",
      }
      file { $maven_dir:
        ensure => directory,
        owner => $user,
        group => $user,
        mode => '0644',
      }
  }

}
