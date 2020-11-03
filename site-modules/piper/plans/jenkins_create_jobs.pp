plan piper::jenkins_create_jobs (
     TargetSpec $targets
   ) {

  #Patch Pipeline Job Builder
     $targets.apply_prep
     $patch_builder_template = "/tmp/patchbuilder-config.xml"
     apply($targets) {
		 		file { $patch_builder_template:
		 			ensure  => file,
					content => epp('piper/patchbuilder-config.xml.epp', {  })
				}
     }
     $targetall = get_targets('all')[0]
     $patch_builder_cmd = "ssh -o \"StrictHostKeyChecking=no\" -l ${targetall.config[ssh][user]}  -p ${targetall.vars[jenkins_cli_port]} localhost  create-job PatchJobBuilder < <(cat ${patch_builder_template})"
     run_command("bash -c \'${patch_builder_cmd}\'", $targets, '_catch_errors' => false, '_run_as' => "${targetall.config[ssh][user]}")

    $generic_builder_template = "/tmp/genericbuilder-config.xml"
    apply($targets) {
    file { $generic_builder_template:
        ensure  => file,
        content => epp('piper/genericbuilder-config.xml.epp', {  })
    }
    }
    $generic_builder_cmd = "ssh -o \"StrictHostKeyChecking=no\" -l ${targetall.config[ssh][user]}  -p ${targetall.vars[jenkins_cli_port]} localhost  create-job GenericPipelineJobBuilder < <(cat ${generic_builder_template})"
    run_command("bash -c \'${generic_builder_cmd}\'", $targets, '_catch_errors' => false, '_run_as' => "${targetall.config[ssh][user]}")
}
