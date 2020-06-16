plan piper::ruby_install (
     TargetSpec $targets
   ) {
     $targets.apply_prep
     apply($targets) {
        class { '::ruby':
          gems_version => 'latest',
       } 
   }
} 
