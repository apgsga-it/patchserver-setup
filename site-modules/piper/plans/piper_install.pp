plan piper::piper_install (
     TargetSpec $targets
   ) {
     $targets.apply_prep
     $yumCmdOptions = "--disablerepo=* --enablerepo=Apg-Piper-Yum*"
     run_command("sudo yum clean all ${yumCmdOptions} && sudo yum -y install ${yumCmdOptions} apg-patch-service-server apg-patch-cli", $targets, '_catch_errors' => true, '_run_as' => 'root')
}
