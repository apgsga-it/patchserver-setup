plan piper::cvs_install (
     TargetSpec $targets
   ) {
     $targets.apply_prep
     apply($targets) {
        yum::install { 'perl':
            ensure => present,
            source => 'https://download-ib01.fedoraproject.org/pub/epel/8/Everything/aarch64/Packages/p/perl-Perl4-CoreLibs-0.004-9.el8.noarch.rpm',
        }
        yum::install { 'cvs':
            ensure => prese
          cnt,
            source => 'https://ftp.rediris.es/mirror/GNU/non-gnu/cvs/binary/stable/x86-linux/RPMS/i386/cvs-1.11.7-1.i386.rpm',
        }
   }
}
