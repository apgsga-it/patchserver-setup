plan piper::test_user_create (
  TargetSpec $targets
) {
  $targets.apply_prep
  $targetall = get_targets('all')[0]
  $r1 = apply($targets) {
      $user = lookup('test::target::user')
      user { $user:
          ensure => present,
          password => Sensitive("${lookup('test::target::pw')}"),
          home => "/home/${user}",
          managehome => true,
      }
  }
}
