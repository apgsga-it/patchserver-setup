plan piper::clean_repo (
  TargetSpec $targets
) {
  $targets.apply_prep
  $targetall = get_targets('all')[0]
  run_command("rm -Rf * ${targetall.vars[maven_home]}/*", $targets, '_catch_errors' => false, '_run_as' => 'root')
  run_command("rm -Rf * ${targetall.vars[gradle_home]}/home/caches/*", $targets, '_catch_errors' => true, '_run_as' => 'root') #Bolt Issue makes mv necessary

}

