plan piper::jenkins_install(
  TargetSpec $targets
) {
  $targets.apply_prep

  ## User Setup
  run_command('groupadd -f -r jenkins', $targets, '_catch_errors' => false, '_run_as' => 'root')
  run_command('useradd -r -m -c "jenkins user" jenkins -g jenkins', $targets, '_catch_errors' => false, '_run_as' => 'root')
  run_command('mkdir /home/jenkins/.m2', $targets, '_catch_errors' => false, '_run_as' => 'root')

  ## Jenkins JCasc Setup
  run_command('mkdir "/etc/jenkins"', $targets, '_catch_errors' => false, '_run_as' => 'root')
  run_command('mkdir "/etc/jenkins/casc"', $targets, '_catch_errors' => false, '_run_as' => 'root')
  $targetall = get_targets('all')[0]
  apply($targets) {
    file { '/etc/jenkins/casc/jenkins.yaml':
      ensure  => file,
      content => epp('piper/jenkins.yaml.epp', { 'jenkinsuser' => "${targetall.config[ssh][user]}" })
    }
  }
  run_command('chown -R jenkins:jenkins /etc/jenkins', $targets, '_catch_errors' => true, '_run_as' => 'root')
  run_command('chmod 0664 /etc/jenkins/casc/*', $targets, '_catch_errors' => true, '_run_as' => 'root')

  ## Jenkins Gradle and Maven Home Setup
  run_command('mkdir "/var/jenkins"', $targets, '_catch_errors' => false, '_run_as' => 'root')
  run_command("mkdir ${targetall.vars[gradle_home]}", $targets, '_catch_errors' => false, '_run_as' => 'root')
  run_command("mkdir ${targetall.vars[maven_home]}", $targets, '_catch_errors' => false, '_run_as' => 'root')
  upload_file('/tmp/gradlehome',"${targetall.vars[gradle_home]}/", $targets,  '_catch_errors' => false,'_run_as' => 'root' )
  run_command("mv ${targetall.vars[gradle_home]}/gradle ${targetall.vars[gradle_home]}/home", $targets, '_catch_errors' => true, '_run_as' => 'root') #Bolt Issue makes mv necessary
  run_command("chmod u+x ${targetall.vars[gradle_home]}/home/initGradleProfile.sh", $targets, '_catch_errors' => true, '_run_as' => 'root')
  run_command("cd ${targetall.vars[gradle_home]}/home ; ./initGradleProfile.sh  /home/jenkins/.m2 ${targetall.vars[maven_profile]} ${targetall.vars[maven_home]} copySettingsXml", $targets, '_catch_errors' => true, '_run_as' => 'root')
  # Owner Ship and Groups
  run_command('chown -R jenkins:jenkins /home/jenkins/.m2', $targets, '_catch_errors' => true, '_run_as' => 'root')
  run_command("chmod -R 777 ${targetall.vars[gradle_home]}", $targets, '_catch_errors' => true, '_run_as' => 'root')
  run_command("chmod -R 777 ${targetall.vars[maven_home]}", $targets, '_catch_errors' => true, '_run_as' => 'root')
  run_command('chown -R jenkins:jenkins /var/jenkins', $targets, '_catch_errors' => true, '_run_as' => 'root')
  run_command('firewall-cmd --permanent --add-port=8080/tcp', $targets, '_catch_errors' => true, '_run_as' => 'root')
  run_command('firewall-cmd --reload', $targets, '_catch_errors' => true, '_run_as' => 'root')
  run_command("firewall-cmd --permanent --add-port=${targetall.vars[cli_port]}/tcp", $targets, '_catch_errors' => true, '_run_as' => 'root')
  run_command('firewall-cmd --reload', $targets, '_catch_errors' => true, '_run_as' => 'root')
  apply($targets) {
      node default {
        class { 'jenkins':
          version => '2.235.1',
          default_plugins => [],
          purge_plugins => true,
          manage_user => false,
          manage_group => false,
          plugin_hash => {
            'email-ext' => { version =>   '2.69', update_url => $targetall.vars[plugins_repo]}, # Email Extension Plugin
            'timestamper' => { version =>   '1.11.3', update_url => $targetall.vars[plugins_repo]}, # Timestamper
            'emailext-template' => { version =>   '1.1', update_url => $targetall.vars[plugins_repo]}, # Email Extension Template Plugin
            'jdk-tool' => { version =>   '1.0', update_url => $targetall.vars[plugins_repo]}, # JDK Tool Plugin
            'snakeyaml-api' => { version =>   '1.26.4', update_url => $targetall.vars[plugins_repo]}, # Snakeyaml API Plugin
            'configuration-as-code' => { version =>   '1.41', update_url => $targetall.vars[plugins_repo]}, # Configuration as Code Plugin
            'matrix-auth' => { version =>   '2.6.1', update_url => $targetall.vars[plugins_repo]}, # Matrix Authorization Strategy Plugin
            'authorize-project' => { version =>   '1.3.0', update_url => $targetall.vars[plugins_repo]}, # Authorize Project
            'credentials' => { version =>   '2.3.9', update_url => $targetall.vars[plugins_repo]}, # Credentials Plugin
            'structs' => { version =>   '1.20', update_url => $targetall.vars[plugins_repo]}, # Structs Plugin
            'scm-api' => { version =>   '2.6.3', update_url =>$targetall.vars[plugins_repo]}, # SCM API Plugin
            'git' => { version =>   '4.2.2', update_url => $targetall.vars[plugins_repo]}, # Git plugin
            'script-security' => { version =>   '1.73', update_url => $targetall.vars[plugins_repo]}, # Script Security Plugin
            'github' => { version =>   '1.30.0', update_url => $targetall.vars[plugins_repo]}, # GitHub plugin
            'workflow-step-api' => { version =>   '2.22', update_url =>$targetall.vars[plugins_repo]}, # Pipeline: Step API
            'workflow-api' => { version =>   '2.40', update_url => $targetall.vars[plugins_repo]}, # Pipeline: API
            'momentjs' => { version =>   '1.1.1', update_url => $targetall.vars[plugins_repo]}, # JavaScript GUI Lib: Moment.js bundle plugin
            'workflow-support' => { version =>   '3.5', update_url => $targetall.vars[plugins_repo]}, # Pipeline: Supporting APIs
            'pipeline-stage-view' => { version =>   '2.13', update_url => $targetall.vars[plugins_repo]}, # Pipeline: Stage View Plugin
            'pipeline-input-step' => { version =>   '2.11', update_url => $targetall.vars[plugins_repo]}, # Pipeline: Input Step
            'junit' => { version =>   '1.29', update_url => $targetall.vars[plugins_repo]}, # JUnit Plugin
            'h2-api' => { version =>   '1.4.199', update_url => $targetall.vars[plugins_repo]}, # H2 API Plugin
            'command-launcher' => { version =>   '1.4', update_url => $targetall.vars[plugins_repo]}, # Command Agent Launcher Plugin
            'pipeline-graph-analysis' => { version =>   '1.10', update_url => $targetall.vars[plugins_repo]}, # Pipeline Graph Analysis Plugin
            'apache-httpcomponents-client-4-api' => { version =>   '4.5.10-2.0', update_url => $targetall.vars[plugins_repo]}, # Apache HttpComponents Client 4.x API Plugin
            'ant' => { version =>   '1.11', update_url => $targetall.vars[plugins_repo]}, # Ant Plugin
            'pipeline-maven' => { version =>   '3.8.2', update_url => $targetall.vars[plugins_repo]}, # Pipeline Maven Integration Plugin
            'bouncycastle-api' => { version =>   '2.18', update_url =>$targetall.vars[plugins_repo]}, # bouncycastle API Plugin
            'ace-editor' => { version =>   '1.1', update_url => $targetall.vars[plugins_repo]}, # JavaScript GUI Lib: ACE Editor bundle plugin
            'pipeline-milestone-step' => { version =>   '1.3.1', update_url => $targetall.vars[plugins_repo]}, # Pipeline: Milestone Step
            'jquery-detached' => { version =>   '1.2.1',update_url => $targetall.vars[plugins_repo]}, # JavaScript GUI Lib: jQuery bundles (jQuery and jQuery UI) plugin
            'lockable-resources' => { version =>   '2.8', update_url => $targetall.vars[plugins_repo]}, # Lockable Resources plugin
            'workflow-scm-step' => { version =>   '2.11' ,update_url =>$targetall.vars[plugins_repo]}, # Pipeline: SCM Step
            'workflow-cps' => { version =>   '2.80', update_url =>$targetall.vars[plugins_repo]}, # Pipeline: Groovy
            'trilead-api' => { version =>   '1.0.8', update_url => $targetall.vars[plugins_repo]}, # Trilead API Plugin
            'workflow-aggregator' => { version =>   '2.6', update_url => $targetall.vars[plugins_repo]}, # Pipeline
            'ssh-credentials' => { version =>   '1.18.1', update_url => $targetall.vars[plugins_repo]}, # SSH Credentials Plugin
            'token-macro' => { version =>   '2.12', update_url => $targetall.vars[plugins_repo]}, # Token Macro Plugin
            'jira-steps' => { version =>   '1.6.0', update_url => $targetall.vars[plugins_repo]}, # JIRA Pipeline Steps
            'config-file-provider' => { version =>   '3.6.3', update_url => $targetall.vars[plugins_repo]}, # Config File Provider Plugin
            'ssh-steps' => { version =>   '2.0.0', update_url => $targetall.vars[plugins_repo]}, # SSH Pipeline Steps
            'display-url-api' => { version =>   '2.3.2', update_url => $targetall.vars[plugins_repo]}, # Display URL API
            'mailer' => { version =>   '1.32', update_url => $targetall.vars[plugins_repo]}, # Mailer Plugin
            'ivy' => { version =>   '2.1', update_url => $targetall.vars[plugins_repo]}, # Ivy Plugin
            'matrix-project' => { version =>   '1.16', update_url =>$targetall.vars[plugins_repo]}, # Matrix Project Plugin
            'durable-task' => { version =>   '1.34', update_url => $targetall.vars[plugins_repo]}, # Durable Task Plugin
            'workflow-cps-global-lib' => { version =>   '2.16', update_url => $targetall.vars[plugins_repo]}, # Pipeline: Shared Groovy Libraries
            'workflow-durable-task-step' => { version =>   '2.35', update_url => $targetall.vars[plugins_repo]}, # Pipeline: Nodes and Processes
            'workflow-job' => { version =>   '2.39', update_url => $targetall.vars[plugins_repo]}, # Pipeline: Job
            'workflow-basic-steps' => { version =>   '2.20', update_url => $targetall.vars[plugins_repo]}, # Pipeline: Basic Steps
            'gradle' => { version =>   '1.36', update_url => $targetall.vars[plugins_repo]}, # Gradle Plugin
            'javadoc' => { version =>   '1.5', update_url => $targetall.vars[plugins_repo]}, # Javadoc Plugin
            'jsch' => { version =>   '0.1.55.2', update_url => $targetall.vars[plugins_repo]}, # JSch dependency plugin
            'maven-plugin' => { version =>   '3.6', update_url => $targetall.vars[plugins_repo]}, # Maven Integration plugin
            'run-condition' => { version =>   '1.3', update_url => $targetall.vars[plugins_repo]}, # Run Condition Plugin
            'artifactory' => { version =>   '3.6.2', update_url => $targetall.vars[plugins_repo]}, # Artifactory Plugin
            'okhttp-api' => { version =>   '3.12.12.2',update_url => $targetall.vars[plugins_repo]}, # OkHttp Plugin
            'pipeline-stage-tags-metadata' => { version =>   '1.7.0', update_url => $targetall.vars[plugins_repo]}, # Pipeline: Stage Tags Metadata
            'pipeline-build-step' => { version =>   '2.12', update_url =>$targetall.vars[plugins_repo]}, # Pipeline: Build Step
            'cloudbees-folder' => { version =>   '6.14', update_url =>$targetall.vars[plugins_repo]}, # Folders Plugin
            'branch-api' => { version =>   '2.5.6', update_url => $targetall.vars[plugins_repo]}, # Branch API Plugin
            'workflow-multibranch' => { version =>   '2.21', update_url => $targetall.vars[plugins_repo]}, # Pipeline: Multibranch
            'plain-credentials' => { version =>   '1.7', update_url => $targetall.vars[plugins_repo]}, # Plain Credentials Plugin
            'credentials-binding' => { version =>   '1.23', update_url => $targetall.vars[plugins_repo]}, # Credentials Binding Plugin
            'jackson2-api' => { version =>   '2.11.0', update_url => $targetall.vars[plugins_repo]}, # Jackson 2 API Plugin
            'pipeline-model-api' => { version =>   '1.7.0', update_url => $targetall.vars[plugins_repo]}, # Pipeline: Model API
            'pipeline-stage-step' => { version =>   '2.3', update_url => $targetall.vars[plugins_repo]}, # Pipeline: Stage Step
            'github-api' => { version =>   '1.114.2', update_url => $targetall.vars[plugins_repo]}, # GitHub API Plugin
            'pipeline-model-extensions' => { version =>   '1.7.0', update_url => $targetall.vars[plugins_repo]}, # Pipeline: Declarative Extension Points API
            'git-client' => { version =>   '3.2.1', update_url => $targetall.vars[plugins_repo]}, # Git client plugin
            'git-server' => { version =>   '1.9', update_url => $targetall.vars[plugins_repo]}, # GIT server Plugin
            'github-branch-source' => { version =>   '2.8.2', update_url => $targetall.vars[plugins_repo]}, # GitHub Branch Source Plugin
            'pipeline-rest-api' => { version =>   '2.13', update_url => $targetall.vars[plugins_repo]}, # Pipeline: REST API Plugin
            'authentication-tokens' => { version =>   '1.3', update_url => $targetall.vars[plugins_repo]}, # Authentication Tokens API Plugin
            'docker-commons' => { version =>   '1.16', update_url => $targetall.vars[plugins_repo]}, # Docker Commons Plugin
            'docker-workflow' => { version =>   '1.23', update_url => $targetall.vars[plugins_repo]}, # Docker Pipeline
            'handlebars' => { version =>   '1.1.1', update_url => $targetall.vars[plugins_repo]}, # JavaScript GUI Lib: Handlebars bundle plugin
            'pipeline-utility-steps' => { version =>   '2.6.0', update_url => $targetall.vars[plugins_repo]}, # Pipeline Utility Steps
            'pipeline-github' => { version =>   '2.5', update_url => $targetall.vars[plugins_repo]}, # Pipeline: GitHub
            'pipeline-model-definition' => { version =>   '1.7.0', update_url => $targetall.vars[plugins_repo]}, # Pipeline: Declarative
            'cvs' => { version =>   '2.16', update_url => $targetall.vars[plugins_repo]}, # CVS Plug-in
          },
          config_hash => {
            'JENKINS_JAVA_OPTIONS' => { value => '-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false -Dorg.jenkinsci.plugins.durabletask.BourneShellScript.HEARTBEAT_CHECK_INTERVAL=100'
            },
            'PATH' => { value => '/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin:/opt/rbenv/bin'},
            'CASC_JENKINS_CONFIG' => { value => '/etc/jenkins/casc'}
          },
          install_java => false,
          cli          => false,
        }
      }
  }

}
