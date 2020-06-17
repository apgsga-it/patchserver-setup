plan piper::jenkins_install(
  TargetSpec $targets
) {
  $targets.apply_prep
  apply($targets) {
     node default {
        class { 'jenkins':
          install_java => false,
          cli          => false,
        }
        jenkins::plugin {
          'ansicolor' :
            version => '0.3.1';
        }
    }
  }
}
