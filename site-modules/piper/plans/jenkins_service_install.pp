plan piper::jenkins_service_install(
  TargetSpec $targets
) {
  $targets.apply_prep
  $targetall = get_targets('all')[0]
  run_command('firewall-cmd --permanent --add-port=8080/tcp', $targets, '_catch_errors' => true, '_run_as' => 'root')
  run_command('firewall-cmd --reload', $targets, '_catch_errors' => true, '_run_as' => 'root')
  run_command("firewall-cmd --permanent --add-port=${targetall.vars[cli_port]}/tcp", $targets, '_catch_errors' => true, '_run_as' => 'root')
  run_command('firewall-cmd --reload', $targets, '_catch_errors' => true, '_run_as' => 'root')
  apply($targets) {
      node default {
        class { 'jenkins':
          version => '2.235.1',
          ## TODO (che, 16.9) : Work around
          direct_download => 'http://ftp-chi.osuosl.org/pub/jenkins/redhat-stable/jenkins-2.235.1-1.1.noarch.rpm',
          default_plugins => [],
          purge_plugins => true,
          manage_user => false,
          manage_group => false,
          plugin_hash => {
            'timestamper' => { version =>   '1.11.5'}, # Timestamper
            'jdk-tool' => { version =>   '1.4' }, # Oracle Java SE Development Kit Installer Plugin
            'snakeyaml-api' => { version =>   '1.27.0' }, # Snakeyaml API Plugin
            'configuration-as-code' => { version =>   '1.43' }, # Configuration as Code Plugin
            'matrix-auth' => { version =>   '2.6.3' }, # Matrix Authorization Strategy Plugin
            'credentials' => { version =>   '2.3.13' }, # Credentials Plugin
            'git' => { version =>   '4.4.2' }, # Git plugin
            'script-security' => { version =>   '1.74' }, # Script Security Plugin
            'github' => { version =>   '1.31.0' }, # GitHub plugin
            'pipeline-stage-view' => { version =>   '2.15' }, # Pipeline: Stage View Plugin
            'pipeline-input-step' => { version =>   '2.12' }, # Pipeline: Input Step
            'junit' => { version =>   '1.34' }, # JUnit Plugin
            'pipeline-maven' => { version =>   '3.9.3' }, # Pipeline Maven Integration Plugin
            'workflow-cps' => { version =>   '2.83' }, # Pipeline: Groovy
            'trilead-api' => { version =>   '1.0.10' }, # Trilead API Plugin
            'display-url-api' => { version =>   '2.3.3' }, # Display URL API
            'mailer' => { version =>   '1.32.1' }, # Mailer Plugin
            'matrix-project' => { version =>   '1.17' }, # Matrix Project Plugin
            'durable-task' => { version =>   '1.35' }, # Durable Task Plugin
            'workflow-cps-global-lib' => { version =>   '2.17' }, # Pipeline: Shared Groovy Libraries
            'workflow-job' => { version =>   '2.40' }, # Pipeline: Job
            'workflow-basic-steps' => { version =>   '2.21' }, # Pipeline: Basic Steps
            'javadoc' => { version =>   '1.6' }, # Javadoc Plugin
            'maven-plugin' => { version =>   '3.7' }, # Maven Integration plugin
            'artifactory' => { version =>   '3.8.1' }, # Artifactory Plugin
            'okhttp-api' => { version =>   '3.14.9' }, # OkHttp Plugin
            'pipeline-stage-tags-metadata' => { version =>   '1.7.2' }, # Pipeline: Stage Tags Metadata
            'pipeline-build-step' => { version =>   '2.13' }, # Pipeline: Build Step
            'branch-api' => { version =>   '2.6.0' }, # Branch API Plugin
            'workflow-multibranch' => { version =>   '2.22' }, # Pipeline: Multibranch
            'jackson2-api' => { version =>   '2.11.2' }, # Jackson 2 API Plugin
            'pipeline-model-api' => { version =>   '1.7.2' }, # Pipeline: Model API
            'pipeline-stage-step' => { version =>   '2.5' }, # Pipeline: Stage Step
            'github-api' => { version =>   '1.116' }, # GitHub API Plugin
            'pipeline-model-extensions' => { version =>   '1.7.2' }, # Pipeline: Declarative Extension Points API
            'git-client' => { version =>   '3.4.2' }, # Git client plugin
            'github-branch-source' => { version =>   '2.9.0' }, # GitHub Branch Source Plugin
            'pipeline-rest-api' => { version =>   '2.15' }, # Pipeline: REST API Plugin
            'authentication-tokens' => { version =>   '1.4' }, # Authentication Tokens API Plugin
            'docker-commons' => { version =>   '1.17' }, # Docker Commons Plugin
            'docker-workflow' => { version =>   '1.24' }, # Docker Pipeline
            'pipeline-utility-steps' => { version =>   '2.6.1' }, # Pipeline Utility Steps
            'pipeline-github' => { version =>   '2.7' }, # Pipeline: GitHub
            'pipeline-model-definition' => { version =>   '1.7.2' }, # Pipeline: Declarative
            'jquery3-api' => { version =>   '3.5.1-1' }, # JQuery3 API Plugin
            'plugin-util-api' => { version =>   '1.2.5' }, # Plugin Utilities API Plugin
            'echarts-api' => { version =>   '4.8.0-2' }, # ECharts API Plugin
            'job-dsl' => { version =>   '1.77' }, # Job DSL
            'permissive-script-security' => { version =>   '0.6' }, # Permissive Script Security Plugin
            'email-ext' => { version =>   '2.69' }, # Email Extension Plugin
            'emailext-template' => { version =>   '1.1' }, # Email Extension Template Plugin
            'authorize-project' => { version =>   '1.3.0' }, # Authorize Project
            'structs' => { version =>   '1.20' }, # Structs Plugin
            'scm-api' => { version =>   '2.6.3' }, # SCM API Plugin
            'workflow-step-api' => { version =>   '2.22' }, # Pipeline: Step API
            'workflow-api' => { version =>   '2.40' }, # Pipeline: API
            'momentjs' => { version =>   '1.1.1' }, # JavaScript GUI Lib: Moment.js bundle plugin
            'workflow-support' => { version =>   '3.5' }, # Pipeline: Supporting APIs
            'h2-api' => { version =>   '1.4.199' }, # H2 API Plugin
            'command-launcher' => { version =>   '1.4' }, # Command Agent Launcher Plugin
            'pipeline-graph-analysis' => { version =>   '1.10' }, # Pipeline Graph Analysis Plugin
            'apache-httpcomponents-client-4-api' => { version =>   '4.5.10-2.0' }, # Apache HttpComponents Client 4.x API Plugin
            'ant' => { version =>   '1.11' }, # Ant Plugin
            'bouncycastle-api' => { version =>   '2.18' }, # bouncycastle API Plugin
            'ace-editor' => { version =>   '1.1' }, # JavaScript GUI Lib: ACE Editor bundle plugin
            'pipeline-milestone-step' => { version =>   '1.3.1' }, # Pipeline: Milestone Step
            'jquery-detached' => { version =>   '1.2.1' }, # JavaScript GUI Lib: jQuery bundles (jQuery and jQuery UI) plugin
            'lockable-resources' => { version =>   '2.8' }, # Lockable Resources plugin
            'workflow-scm-step' => { version =>   '2.11' }, # Pipeline: SCM Step
            'workflow-aggregator' => { version =>   '2.6' }, # Pipeline
            'ssh-credentials' => { version =>   '1.18.1' }, # SSH Credentials Plugin
            'token-macro' => { version =>   '2.12' }, # Token Macro Plugin
            'jira-steps' => { version =>   '1.6.0' }, # JIRA Pipeline Steps
            'config-file-provider' => { version =>   '3.6.3' }, # Config File Provider Plugin
            'ssh-steps' => { version =>   '2.0.0' }, # SSH Pipeline Steps
            'ivy' => { version =>   '2.1' }, # Ivy Plugin
            'workflow-durable-task-step' => { version =>   '2.35' }, # Pipeline: Nodes and Processes
            'gradle' => { version =>   '1.36' }, # Gradle Plugin
            'jsch' => { version =>   '0.1.55.2' }, # JSch dependency plugin
            'run-condition' => { version =>   '1.3' }, # Run Condition Plugin
            'cloudbees-folder' => { version =>   '6.14' }, # Folders Plugin
            'plain-credentials' => { version =>   '1.7' }, # Plain Credentials Plugin
            'credentials-binding' => { version =>   '1.23' }, # Credentials Binding Plugin
            'git-server' => { version =>   '1.9' }, # GIT server Plugin
            'handlebars' => { version =>   '1.1.1' }, # JavaScript GUI Lib: Handlebars bundle plugin
            'cvs' => { version =>   '2.16' }, # CVS Plug-in
          },
          config_hash => {
            'JENKINS_JAVA_OPTIONS' => { value => '-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false -Dorg.jenkinsci.plugins.durabletask.BourneShellScript.HEARTBEAT_CHECK_INTERVAL=100 -Dpermissive-script-security.enabled=no_security'
            },
            'PATH' => { value => '/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin'},
            'CASC_JENKINS_CONFIG' => { value => '/etc/jenkins/casc'}
          },
          install_java => false,
          cli          => false,
        }
      }
  }

}
