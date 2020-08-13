#!/usr/bin/env ruby
# encoding: utf-8
require "slop"
require 'json'
require 'readline'
require 'highline/import'
require_relative 'lib/jenkins'
require_relative 'lib/artifactory'


class TestAppsJobBuilder < Jenkins::BaseVisitor
  attr_reader :opts, :mavenRenderer
  include Jenkins

  def initialize(opts)
    @opts = opts
  end

  def visit_TestApps(subject)
    puts "Starting Build of Jenkins Jobs for TestApps"
  end

  def visit_MavenModule(subject)
    Jenkins::BuildJob.new(subject.target, subject.user, job_name(subject.name), @opts[:dry]).run
  end

  def visit_PkgModule(subject)
    Jenkins::BuildJob.new(subject.target, subject.user, job_name(subject.name), opts[:dry]).run
  end
end

def clean_caches(opts)
  current_dir = Dir.pwd
  Dir.chdir("..")
  cmd = "./install.rb -i clean_repo"
  if (opts[:dry])
    cmd << " --dry"
  end
  puts cmd
  system(cmd)
  Dir.chdir(current_dir)
end
def buildJobs(test_apps,opts)
  # Starting and executing all Test Builds sequentially ana waiting on their output
  test_apps.accept(TestAppsJobBuilder.new(opts))
end

def clean_repos(test_apps, opts)
  user = ask("Enter artifactory userid: ")
  password = ask("Enter artifactory password: ") { |q| q.echo = false }
  command = Artifactory::Cli.new(test_apps.artifactory_uri, user, password, opts[:dry])
  user_filter = test_apps.maven_profile[test_apps.maven_profile.index('-')+1..-1]
  command.clean_repositories(command.list_repositories(user_filter), opts[:dry])
  puts "done."
end

def help(opts)
  puts "This script initializes Tests for Piper in the Target VM as defined in the inventory.yaml file\n\n" +
           "Preconditions: \n" +
           "- Jenkins is running on the Target host and ssh access works for the Jenkins Cli\n" +
           "- The Test Jobs have been created in Jenkins\n" +
           "- The test modules needs to be in cvs.apgsga.ch\n\n" +
           "Functionality: \n" +
           "- It deletes local Maven and Gradle caches on the the target host \n" +
           "- In empties the Artifactory according the Maven Profile settings \n" +
           "- It builds all Testjobs according to inventory.xml \n\n"
  puts opts
end

opts = Slop.parse do |o|
  o.bool '-y', '--dry', 'Dry run, without invoking Jenkins cli via ssh', default: false
  o.bool '-scc', '--skipCacheClean', 'Skip cleaning of Maven and Gradle Cache', default: false
  o.bool '-srj', '--skipRunJobs', 'Skip running of Build Jobs ', default: false
  o.bool '-src', '--skipReposClean', 'Skip cleaning of Repos', default: false
  o.on '-h', '--help' do
    help(o)
    exit
  end
end

if opts[:dry]
  puts "Dry run! No changes will be made"
end
# Cleaning up Local Gradle and Maven Cache
test_apps = Jenkins::TestApps.new
if !opts[:skipCacheClean]
  clean_caches(opts)
else
  puts "Skipping clean of Caches"
end
if !opts[:skipReposClean]
  clean_repos(test_apps, opts)
else
  puts "Skipping Running of Build Jobs"
end
if !opts[:skipRunJobs]
  buildJobs(test_apps,opts)
else
  puts "Skipping Running of Build Jobs"
end
if opts[:dry]
  puts "Dry run! No changes have been be made"
end
puts "Done."

