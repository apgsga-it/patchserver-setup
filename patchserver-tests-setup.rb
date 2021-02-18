#!/usr/bin/env ruby
# frozen_string_literal: true

require 'slop'
require 'json'
require 'readline'
require 'highline/import'
require 'pathname'
require 'apgsecrets'
require 'artcli'
require_relative 'ruby-testlibs/jenkins'

def run_remote_sudo_cmd(user, pw, target, cmd, opts)
  cmd = "ssh #{user}@#{target} cat \\| sudo --prompt=\"\" -S -- '#{cmd}' <<EOF"
  puts "Running remote sudo cmd: #{cmd}"
  if opts[:dry]
    puts 'Dry modus, not executed'
    return
  end
  cmd += "\n#{pw}\nEOF"
  pipe = IO.popen(cmd, 'r+')
  puts pipe.readlines
end

def clean_maven_cache(test_apps, opts)
  verbose = 'v' if opts[:verbose]
  run_remote_sudo_cmd(test_apps.user, test_apps.pw, test_apps.target, "rm -Rf#{verbose} #{test_apps.maven_home}/*", opts)
end

def clean_gradle_cache(test_apps, opts)
  verbose = 'v' if opts[:verbose]
  run_remote_sudo_cmd(test_apps.user, test_apps.pw, test_apps.target, "rm -Rf#{verbose} #{test_apps.gradle_home}/home/caches/*", opts)
end

def clean_revisions(test_apps, opts)
  verbose = 'v' if opts[:verbose]
  run_remote_sudo_cmd(test_apps.user, test_apps.pw, test_apps.target, "rm -Rf#{verbose} #{test_apps.gradle_home}/home/Revision*", opts)
end

def clean_artifactory_repos(test_apps, opts)
  secrets = Secrets::Store.new("Patchservertestsetup-artifactory-local")
  admin_user = opts[:artifactoryAdmin] ? opts[:artifactoryAdmin] :  test_apps.user
  secrets.prompt_only_when_not_exists(admin_user, "Enter artifactory password for admin user: #{admin_user} and enter return:", opts[:force])
  command = Artcli::Cli.new(test_apps.artifactory_uri, admin_user, secrets.retrieve(admin_user), opts[:dry])
  user_filter = test_apps.maven_profile[test_apps.maven_profile.index('-') + 1..-1]
  command.clean_repositories_interactive(user_filter)
end

def help(opts)
  puts "This script initializes Tests for Piper in the Target VM as defined in the Bolt Puppet Inventory Files : inventory.yaml and inventory-local.yaml\n\n" \
       "Preconditions: \n" \
  "- Jenkins is running on the Target host and ssh access works for the Jenkins Cli\n" \
  "- The test modules as specified in inventory-local.yaml need to be in cvs.apgsga.ch\n\n"
  puts opts
end

opts = Slop.parse do |o|
  o.string '-u', '--user', 'SSH Sudo Username to access destination VM', required: true
  o.string '-au', '--artAdmin', 'User for Artifactory operations, if not present defaults to the -u user', required: false
  o.bool '-y', '--dry', 'Dry run, the effective and rsspective commands will not be executed, default: false', default: false
  o.bool '-cc', '--cleanRepoCaches', 'Cleans Maven and Gradle Cache, default: false', default: false
  o.bool '-cm', '--cleanMavenCache', 'Cleans Maven, default: false', default: false
  o.bool '-cg', '--cleanGradleCache', 'Cleans Maven, default: false', default: false
  o.bool '-ct', '--cleanArtifactory', 'Cleans the specific repos in Artifactory according to Profile, default: false', default: false
  o.bool '-cr', '--cleanRevisions', 'Remove all revision files, default: false', default: false
  o.bool '-ca', '--cleanAll', 'Execute all clean options, default: false', default: false
  o.bool '-rjs', '--runAllJobs', 'Run all the Testsapps Jobs, default: false', default: false
  o.bool '-djs', '--deleteAllJobs', 'Delete all the Testsapps Jobs , default: false', default: false
  o.bool '-cjs', '--createAllJobs', 'Create all the Testsapps Jobs , default: false', default: false
  o.string '-rj', '--runAppJobs', 'Run the Jobs of a specific TestApp of a <Testappname>'
  o.string '-dj', '--deleteAppJobs', 'Delete the Jobs of a specific TestApp of a <Testappname>'
  o.string '-cj', '--createAppJobs', 'Create the Jobs of a specific TestApp of a <Testappname>'
  o.bool '-p', '--print', 'Prints out Testapp Metadata, default: false', default: false
  o.bool '-spk', '--skipPkgs', 'Skip the builds of the Test Pkgs, default: false', default: false
  o.bool '-v', '--verbose', 'Enable verbose output, default: false', default: false
  o.bool '-f', '--force', 'Force prompting of password, default: false', default: false
  o.on '-h', '--help' do
    help(o)
    exit
  end
end

# Preconditions
# Bolt Inventory File check
inventory_file = File.join(File.dirname(__FILE__), "inventory.yaml")
if !File.exist?(inventory_file) || !File.readable?(inventory_file)
  help(opts)
  puts "The Bolt inventory file #{inventory_file} does not exist or isn't a file"
  exit
end
# Bolt Inventory File check
inventory_local_file = File.join(File.dirname(__FILE__), "inventory-local.yaml")
if !File.exist?(inventory_local_file) || !File.readable?(inventory_local_file)
  help(opts)
  puts "The Bolt local inventory file #{inventory_local_file} does not exist or isn't a file"
  exit
end

# Main line
secrets = Secrets::Store.new("Patchservertestsetup-target-local",86400)
secrets.prompt_only_when_not_exists(opts[:user], "Please enter pw for user: #{opts[:user]} for local vm test and hit return:     ",opts[:force])
puts " "
puts 'Dry run! No changes will be made' if opts[:dry]
test_apps = Jenkins::TestApps.new(opts[:user],secrets, inventory_file, inventory_local_file)
clean_maven_cache(test_apps, opts) if opts[:cleanRepoCaches] or  opts[:cleanAll] or  opts[:cleanMavenCache]
clean_gradle_cache(test_apps, opts) if opts[:cleanRepoCaches] or  opts[:cleanAll] or  opts[:cleanGradleCache]
clean_artifactory_repos(test_apps, opts) if opts[:cleanArtifactory] or  opts[:cleanAll]
clean_revisions(test_apps, opts) if opts[:cleanRevisions] or  opts[:cleanAll]
test_apps.accept(Jenkins::TestAppsPrinter.new) if opts[:print]
test_apps.accept(Jenkins::TestAppsJobDeleter.new(opts)) if opts[:deleteAllJobs] or opts[:deleteAppJobs]
test_apps.accept(Jenkins::TestAppsJobCreator.new(opts)) if opts[:createAllJobs] or opts[:createAppJobs]
test_apps.accept(Jenkins::TestAppsJobRunner.new(opts)) if opts[:runAllJobs] or opts[:runAppJobs]
puts 'Dry run! No changes have been be made' if opts[:dry]
puts 'Done.'
