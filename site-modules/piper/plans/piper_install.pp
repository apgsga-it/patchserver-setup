plan piper::piper_install (
     TargetSpec $targets
   ) {
     $targets.apply_prep
     $yumCmdOptions = "--disablerepo=* --enablerepo=Apg-Piper-Yum*"
     run_command("sudo yum clean all ${yumCmdOptions} && sudo yum -y install ${yumCmdOptions} apg-patch-service-server apg-patch-cli", $targets, '_catch_errors' => true, '_run_as' => 'root')
  # Quick fix for missing apg user / groups
    run_command("chmod a+r /etc/opt/apg-patch-cli/ops.properties", $targets, '_catch_errors' => true, '_run_as' => 'root')
}
