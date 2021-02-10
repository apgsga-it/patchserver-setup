plan piper::apscli_remote_test_config(
  TargetSpec $targets
) {
  $targets.apply_prep
  $targetall = get_targets('all')[0]
  run_command("firewall-cmd --permanent --add-port=${targetall.vars[piper_server_port]}/tcp", $targets, '_catch_errors' => true, '_run_as' => 'root')
  run_command('firewall-cmd --reload', $targets, '_catch_errors' => true, '_run_as' => 'root')
  $applyResult = apply($targets) {
      file_line { "/etc/opt/apg-patch-service-server/application.properties":
        ensure            => absent,
        path              => '/etc/opt/apg-patch-service-server/application.properties',
        line              => 'server.address=',
        match             => '^server.address=',
        match_for_absence => true,
        notify => Service['apg-patch-service-server']
      }
      service { 'apg-patch-service-server':
        name => 'apg-patch-service-server',
        ensure => running,
      }
  }

}
