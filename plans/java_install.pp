plan piper::java_install(
  TargetSpec $targets
    ) {
      $targets.apply_prep
      apply($targets) {
      class { 'java':
      package => 'java-1.8.0-openjdk-devel'
    }
  }
}
