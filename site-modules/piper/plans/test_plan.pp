plan piper::test_plan(
  TargetSpec $targets
) {
  $targets.apply_prep
  $targetall = get_targets('all')[0]
  run_command("echo ${targetall.vars[hello]}", $targets, '_catch_errors' => false, '_run_as' => 'root')
  run_command("echo ${targetall.config[ssh][user]}", $targets, '_catch_errors' => false, '_run_as' => 'root')
  run_script('piper/cloneGradleHome.sh', $targets, 'arguments' =>  ["${targetall.config[ssh][user]}"])

}

