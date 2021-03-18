plan piper::cvs_install (
     TargetSpec $targets
   ) {
     $targets.apply_prep
     apply($targets) {
        yum::install { 'cvs':
            ensure => present,
            source => 'https://ftp.rediris.es/mirror/GNU/non-gnu/cvs/binary/stable/x86-linux/RPMS/i386/cvs-1.11.7-1.i386.rpm',
        }
   }
}
