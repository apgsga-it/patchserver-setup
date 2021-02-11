plan piper::jenkins_gradle_home (
  TargetSpec $targets,
  String $user
) {
  $targets.apply_prep
  $targetall = get_targets('all')[0]
  apply($targets) {

    exec { "git clone ${user}@git.apgsga.ch:/var/git/repos/apg-gradle-properties.git ${targetall.vars[gradle_home]}/home":
      cwd     => "${targetall.vars[gradle_home]}/home",
      path     => [ '/usr/bin'],
      user    => $jenkins_user,
      group   => $jenkins_user,
    }
    file { "${targetall.vars[gradle_home]}/home/initGradleProfile.sh":
      ensure  => file,
      owner => $jenkins_user,
      group => $jenkins_user,
      mode => '0700',
    }
    exec { "./initGradleProfile.sh  /home/jenkins/.m2 ${targetall.vars[maven_profile]} ${targetall.vars[maven_home]} copySettingsXml":
      cwd     => "${targetall.vars[gradle_home]}/home",
      path     => [ '/usr/bin'],
      user    => $jenkins_user,
      group   => $jenkins_user,
    }
  }



}
