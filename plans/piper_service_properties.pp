plan piper::piper_service_properties (
     TargetSpec $targets,
     String $user
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
     $artifactory_repo_default = $targetall.vars[artifactory_repo_base]
     if $targetall.facts[environment] == "development" {
        $artifactory_repo = "dev${user}-${artifactory_repo_default}"
      } elsif $targetall.facts[environment] == "integration"{
        $artifactory_repo = "${artifactory_repo_default}-test"
      } else {
        $artifactory_repo = "${artifactory_repo_default}"
      }
     ['application', 'ops'].each  |$type| {
          $result = download_file("/etc/opt/apg-patch-service-server/${type}_properties.initial", 'piper', $targets)
          out::message($result)
          $applyResult = apply($targets) {
            $content = epp($result.first['path'], { 'piper_cvs_user' => "${targetall.vars[cvs_user]}",
           'jenkins_ssh_user' => "${targetall.vars[piper_jenkins_user]}",
           'artifactory_repo' => $artifactory_repo ,
           'artifactory_user' => "${lookup('piper::artifactory::user')}",
           'artifactory_passwd' => "${lookup('piper::artifactory::pw')}",
           'cm_db_piper_user' => "${lookup('piper::cm::db::user')}",
           'cm_db_piper_pw' => "${lookup('piper::cm::db::pw')}"})
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
