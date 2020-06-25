plan piper::git_install (
     TargetSpec $targets
   ) {
     $targets.apply_prep
     apply($targets) {
     class{ 'git':
        sources_ensure  => present,
        package_ensure  => latest,
        package_name    => 'git',
      }
   }
}
