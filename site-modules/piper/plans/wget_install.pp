plan piper::wget_install (
     TargetSpec $targets
   ) {
     $targets.apply_prep
     apply($targets) {
     class{ 'wget':
        package_manage  => true,
        package_ensure  => present,
        package_name    => 'wget',
      }
   }
}
