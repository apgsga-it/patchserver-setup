plan piper::jenkins_create_jobs (
     TargetSpec $targets,
     TargetSpec $user
   ) {

    #Patch Pipeline Job Builder
     $targets.apply_prep
     $targetall = get_targets('all')[0]
     $templates_names = ['patchbuilder-config', 'genericbuilder-config','delete-locks-config','cvs-branch-config','patchConflictNotificationPipeline-config']
     $job_names = ['PatchJobBuilder','GenericPipelineJobBuilder','DeleteLocksJob','CvsBranchJob','patchConflictNotificationPipeline']
     zip($templates_names,$job_names).each  |$template_row| {
        $template_name = $template_row[0]
        $job_name = $template_row[1]
        $template_file = "/tmp/${template_name}.xml"
        apply($targets) {
          file { $template_file:
            ensure  => file,
            content => epp("piper/${template_name}.xml.epp", {  })
          }
        }
        $cmd = "ssh -o \"StrictHostKeyChecking=no\" -l ${user}  -p ${targetall.vars[jenkins_cli_port]} localhost  create-job ${job_name} < <(cat ${template_file})"
        $command_result = run_command("bash -c \'${cmd}\'", $targets, '_catch_errors' => true, '_run_as' => "${user}")
        $result = case $command_result {
          # When the plan returned a ResultSet use it.
          ResultSet: { $command_result }
          # If the run_task failed extract the result set from the error.
          Error['bolt/run-failure'] : { $command_result.details['result_set'] }
          # The sub-plan failed for an unexpected reason.
          default : { fail_plan("$command_result") }
        }
        if !$result.ok {
          $std_err = $result.first.value['stderr']
          if $std_err and  !$std_err.empty {
            $rs = $std_err =~ /already exists/
            if $rs {
              out::message($std_err)
              out::message("But continueing, since Job ${job_name} already exists")
            } else {
              fail_plan("$command_result")
            }
          } else {
            out::message("Creating Job ${job_name} completed.")
          }
        }
     }
}

