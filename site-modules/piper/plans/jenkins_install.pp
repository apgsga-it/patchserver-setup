plan piper::jenkins_install(
  TargetSpec $targets
) {
  $targets.apply_prep
  run_script('piper/casc-dir-create.sh', $targets, '_run_as' => 'root')
  upload_file('piper/jenkins.yaml', '/etc/jenkins/casc/jenkins.yaml', $targets)
  run_script('piper/casc-dir-chmod.sh', $targets, '_run_as' => 'root')
  apply($targets) {
      node default {
        class { 'jenkins':
          version => '2.235.1',
          default_plugins => [],
          purge_plugins => true,
          plugin_hash => {
            'jdk-tool' => { version =>   '1.0'}, # JDK Tool Plugin
            'snakeyaml-api' => { version =>   '1.26.4'}, # Snakeyaml API Plugin
            'configuration-as-code' => { version =>   '1.41'}, # Configuration as Code Plugin
            'matrix-auth' => { version =>   '2.6.1'}, # Matrix Authorization Strategy Plugin
            'authorize-project' => { version =>   '1.3.0'}, # Authorize Project
            'credentials' => { version =>   '2.3.9'}, # Credentials Plugin
            'structs' => { version =>   '1.20'}, # Structs Plugin
            'scm-api' => { version =>   '2.6.3'}, # SCM API Plugin
            'git' => { version =>   '4.2.2'}, # Git plugin
            'script-security' => { version =>   '1.73'}, # Script Security Plugin
            'github' => { version =>   '1.30.0'}, # GitHub plugin
            'workflow-step-api' => { version =>   '2.22'}, # Pipeline: Step API
            'workflow-api' => { version =>   '2.40'}, # Pipeline: API
            'momentjs' => { version =>   '1.1.1'}, # JavaScript GUI Lib: Moment.js bundle plugin
            'workflow-support' => { version =>   '3.5'}, # Pipeline: Supporting APIs
            'pipeline-stage-view' => { version =>   '2.13'}, # Pipeline: Stage View Plugin
            'pipeline-input-step' => { version =>   '2.11'}, # Pipeline: Input Step
            'junit' => { version =>   '1.29'}, # JUnit Plugin
            'h2-api' => { version =>   '1.4.199'}, # H2 API Plugin
            'command-launcher' => { version =>   '1.4'}, # Command Agent Launcher Plugin
            'pipeline-graph-analysis' => { version =>   '1.10'}, # Pipeline Graph Analysis Plugin
            'apache-httpcomponents-client-4-api' => { version =>   '4.5.10-2.0'}, # Apache HttpComponents Client 4.x API Plugin
            'ant' => { version =>   '1.11'}, # Ant Plugin
            'pipeline-maven' => { version =>   '3.8.2'}, # Pipeline Maven Integration Plugin
            'bouncycastle-api' => { version =>   '2.18'}, # bouncycastle API Plugin
            'ace-editor' => { version =>   '1.1'}, # JavaScript GUI Lib: ACE Editor bundle plugin
            'pipeline-milestone-step' => { version =>   '1.3.1'}, # Pipeline: Milestone Step
            'jquery-detached' => { version =>   '1.2.1'}, # JavaScript GUI Lib: jQuery bundles (jQuery and jQuery UI) plugin
            'lockable-resources' => { version =>   '2.8'}, # Lockable Resources plugin
            'workflow-scm-step' => { version =>   '2.11'}, # Pipeline: SCM Step
            'workflow-cps' => { version =>   '2.80'}, # Pipeline: Groovy
            'trilead-api' => { version =>   '1.0.8'}, # Trilead API Plugin
            'workflow-aggregator' => { version =>   '2.6'}, # Pipeline
            'ssh-credentials' => { version =>   '1.18.1'}, # SSH Credentials Plugin
            'token-macro' => { version =>   '2.12'}, # Token Macro Plugin
            'jira-steps' => { version =>   '1.6.0'}, # JIRA Pipeline Steps
            'config-file-provider' => { version =>   '3.6.3'}, # Config File Provider Plugin
            'ssh-steps' => { version =>   '2.0.0'}, # SSH Pipeline Steps
            'display-url-api' => { version =>   '2.3.2'}, # Display URL API
            'mailer' => { version =>   '1.32'}, # Mailer Plugin
            'ivy' => { version =>   '2.1'}, # Ivy Plugin
            'matrix-project' => { version =>   '1.16'}, # Matrix Project Plugin
            'durable-task' => { version =>   '1.34'}, # Durable Task Plugin
            'workflow-cps-global-lib' => { version =>   '2.16'}, # Pipeline: Shared Groovy Libraries
            'workflow-durable-task-step' => { version =>   '2.35'}, # Pipeline: Nodes and Processes
            'workflow-job' => { version =>   '2.39'}, # Pipeline: Job
            'workflow-basic-steps' => { version =>   '2.20'}, # Pipeline: Basic Steps
            'gradle' => { version =>   '1.36'}, # Gradle Plugin
            'javadoc' => { version =>   '1.5'}, # Javadoc Plugin
            'jsch' => { version =>   '0.1.55.2'}, # JSch dependency plugin
            'maven-plugin' => { version =>   '3.6'}, # Maven Integration plugin
            'run-condition' => { version =>   '1.3'}, # Run Condition Plugin
            'artifactory' => { version =>   '3.6.2'}, # Artifactory Plugin
            'okhttp-api' => { version =>   '3.12.12.2'}, # OkHttp Plugin
            'pipeline-stage-tags-metadata' => { version =>   '1.7.0'}, # Pipeline: Stage Tags Metadata
            'pipeline-build-step' => { version =>   '2.12'}, # Pipeline: Build Step
            'cloudbees-folder' => { version =>   '6.14'}, # Folders Plugin
            'branch-api' => { version =>   '2.5.6'}, # Branch API Plugin
            'workflow-multibranch' => { version =>   '2.21'}, # Pipeline: Multibranch
            'plain-credentials' => { version =>   '1.7'}, # Plain Credentials Plugin
            'credentials-binding' => { version =>   '1.23'}, # Credentials Binding Plugin
            'jackson2-api' => { version =>   '2.11.0'}, # Jackson 2 API Plugin
            'pipeline-model-api' => { version =>   '1.7.0'}, # Pipeline: Model API
            'pipeline-stage-step' => { version =>   '2.3'}, # Pipeline: Stage Step
            'github-api' => { version =>   '1.114.2'}, # GitHub API Plugin
            'pipeline-model-extensions' => { version =>   '1.7.0'}, # Pipeline: Declarative Extension Points API
            'git-client' => { version =>   '3.2.1'}, # Git client plugin
            'git-server' => { version =>   '1.9'}, # GIT server Plugin
            'github-branch-source' => { version =>   '2.8.2'}, # GitHub Branch Source Plugin
            'pipeline-rest-api' => { version =>   '2.13'}, # Pipeline: REST API Plugin
            'authentication-tokens' => { version =>   '1.3'}, # Authentication Tokens API Plugin
            'docker-commons' => { version =>   '1.16'}, # Docker Commons Plugin
            'docker-workflow' => { version =>   '1.23'}, # Docker Pipeline
            'handlebars' => { version =>   '1.1.1'}, # JavaScript GUI Lib: Handlebars bundle plugin
            'pipeline-utility-steps' => { version =>   '2.6.0'}, # Pipeline Utility Steps
            'pipeline-github' => { version =>   '2.5'}, # Pipeline: GitHub
            'pipeline-model-definition' => { version =>   '1.7.0'}, # Pipeline: Declarative
            'cvs' => { version =>   '2.16'}, # CVS Plug-in
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
  run_script('piper/jenkins-open-port.sh', $targets, '_run_as' => 'root')

}
