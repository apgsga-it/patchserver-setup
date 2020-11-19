plan piper::piper_service_properties (
     TargetSpec $targets
   ) {
     $targets.apply_prep
     $applyResultStopped = apply($targets) {
        service { 'apg-patch-service-server':
            name => 'apg-patch-service-server',
            ensure => stopped,
        }
      }
     $timestamp = Timestamp.new().strftime('%Y-%m-%dT%H:%M:%S%:z')
     $targetall = get_targets('all')[0]
     ['application', 'ops'].each  |$type| {
          $result = download_file("/etc/opt/apg-patch-service-server/${type}_properties.initial", 'piper', $targets)
          out::message($result)
          $applyResult = apply($targets) {
            $content = epp($result.first['path'], { 'piper_cvs_user' => "${targetall.config[ssh][user]}", 'jenkins_ssh_user' => "${targetall.config[ssh][user]}" })
            file { "/etc/opt/apg-patch-service-server/${type}.properties":
              ensure  => present,
              backup => ".puppet.bk.${timestamp}",
              content => $content,
              owner => 'apg-patch-service-server',
              group => 'apg-patch-service-server',
              mode => '0644',
            }
          }
     }
    $applyResultStart = apply($targets) {
        service { 'apg-patch-service-server':
            name => 'apg-patch-service-server',
            ensure => running,
        }
    }
}
