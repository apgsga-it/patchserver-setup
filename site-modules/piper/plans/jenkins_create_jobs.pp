plan piper::jenkins_create_jobs (
     TargetSpec $targets
   ) {
     $targets.apply_prep
     $templatefile = "/tmp/patchbuilder-config.xml"
     apply($targets) {
		 		file { $templatefile:
		 			ensure  => file,
					content => epp('piper/patchbuilder-config.xml.epp', {  })
				}
     }
     $targetall = get_targets('all')[0]
     $cmd = "ssh -o \"StrictHostKeyChecking=no\" -l ${targetall.config[ssh][user]}  -p ${targetall.vars[cli_port]} localhost  create-job PatchJobBuilder < <(cat ${templatefile})"
     run_command("bash -c \'${cmd}\'", $targets, '_catch_errors' => false, '_run_as' => "${targetall.config[ssh][user]}")
}
