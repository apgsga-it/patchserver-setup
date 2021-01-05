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

def clean_caches(testsapps, opts)
  verbose = if opts[:verbose]
              'v'
            else
              ''
            end
  run_remote_sudo_cmd(testsapps.user, testsapps.pw, testsapps.target, "rm -Rf#{verbose} #{testsapps.maven_home}/*", opts)
  run_remote_sudo_cmd(testsapps.user, testsapps.pw, testsapps.target, "rm -Rf#{verbose} #{testsapps.gradle_home}/home/caches/*", opts)
end

def clean_repos(test_apps, opts)
  secrets = Secrets::Store.new("Patchservertests")
  secrets.prompt_only_when_not_exists(test_apps.user, 'Enter artifactory password and enter return:', opts[:force])
  command = Artcli::Cli.new(test_apps.artifactory_uri, test_apps.artifactory_admin, secrets.retrieve(test_apps.user), opts[:dry])
  user_filter = test_apps.maven_profile[test_apps.maven_profile.index('-') + 1..-1]
  command.clean_repositories_interactive(user_filter)
end

def help(opts)
  puts "This script initializes Tests for Piper in the Target VM as defined in the testappsconfig.yaml file and the Bolt Puppet Inventory File\n\n" \
       "Preconditions: \n" \
  "- Jenkins is running on the Target host and ssh access works for the Jenkins Cli\n" \
  "- The test modules as specified in testappsconfig.yaml need to be in cvs.apgsga.ch\n\n" \
  "Functionality as options: \n" \
  "- Deletes mavenLocal and the gradle Cache on the the target host \n" \
  "- Empties the Artifactory according the Maven Profile settings \n" \
  "- Creates the Testjobs according to testappsconfig.yaml  \n" \
  "- Deletes all Testjobs according to  testappsconfig.yam\n" \
  "- Runs all Testjobs according to  testappsconfig.yaml \n\n"
  puts opts
end

opts = Slop.parse do |o|
  o.string '-i', '--inventory', 'Location Bolt Puppet Inventory File to Patchserver Setup, default: "./inventory.yaml"', default: './inventory.yaml'
  o.string '-c', '--config', 'Location Testapps Metadata config, default: "./testappsconfig.yaml"', default: './testappsconfig.yaml'
  o.bool '-y', '--dry', 'Dry run, the effective and rsspective commands will not be executed, default: false', default: false
  o.bool '-cc', '--cleanCache', 'Cleans Maven and Gradle Cache, default: false', default: false
  o.bool '-ca', '--cleanArtifactory', 'Cleans the specific repos in Artifactory according to Profile, default: false', default: false
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
inventory_path = Pathname.new(opts[:inventory])
inventory_file = if inventory_path.absolute?
                   File.dirname(inventory_path)
                 else
                   File.join(File.dirname(__FILE__), inventory_path)
                 end
if !File.exist?(inventory_file) || !File.readable?(inventory_file)
  help(opts)
  puts "The Bolt inventory file #{inventory_path} does not exist or isn't a file"
  exit
end
# Testapps Config File
config_path = Pathname.new(opts[:config])
config_file = if config_path.absolute?
                File.dirname(config_path)
              else
                File.join(File.dirname(__FILE__), config_path)
              end
if !File.exist?(config_file) || !File.readable?(config_file)
  help(opts)
  puts "The Testapp Config file #{config_path} does not exist or isn't a file"
  exit
end
# Main line
puts 'Dry run! No changes will be made' if opts[:dry]
test_apps = Jenkins::TestApps.new(inventory_file, config_file)
clean_caches(test_apps, opts) if opts[:cleanCache]
clean_repos(test_apps, opts) if opts[:cleanArtifactory]
test_apps.accept(Jenkins::TestAppsPrinter.new) if opts[:print]
test_apps.accept(Jenkins::TestAppsJobDeleter.new(opts)) if opts[:deleteAllJobs] or opts[:deleteAppJobs]
test_apps.accept(Jenkins::TestAppsJobCreator.new(opts)) if opts[:createAllJobs] or opts[:createAppJobs]
test_apps.accept(Jenkins::TestAppsJobRunner.new(opts)) if opts[:runAllJobs] or opts[:runAppJobs]
puts 'Dry run! No changes have been be made' if opts[:dry]
puts 'Done.'
