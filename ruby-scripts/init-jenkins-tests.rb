#!/usr/bin/env ruby
# encoding: utf-8
require "slop"
require 'sshkit'
require 'sshkit/dsl'
require "artifactory"
require 'json'
require 'readline'
require 'highline/import'
include SSHKit::DSL
require_relative 'lib/jenkins'


class InteractiveSudo
  attr_reader :inventory
  def initialize(data)
    @inventory = data
  end
  def on_data(command, stream_name, data, channel)
    channel.send_data("#{@inventory.pw}\n")
  end
end


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

def clean_caches(test_apps)
  SSHKit::Backend::Netssh.config.pty = 1
  on "#{test_apps.user}@#{test_apps.target}" do
    within "#{test_apps.gradle_home}/home" do
      execute(:sudo, :rm, '-Rf caches/*', :interaction_handler => INTERACTIVE_SUDO)
    end
    within "#{test_apps.maven_home}" do
      execute(:sudo, :rm, '-Rf *', :interaction_handler => INTERACTIVE_SUDO)
    end
  end
end
def buildJobs(test_apps,opts)
  # Starting and executing all Test Builds sequentially ana waiting on their output
  test_apps.accept(TestAppsJobBuilder.new(opts))
end

def clean_repos(test_apps, opts)
  artifactory_endpoint = 'https://artifactory4t4apgsga.jfrog.io/artifactory'
  client = Artifactory::Client.new(endpoint: artifactory_endpoint, username: "#{opts[:user]}", password: "#{opts[:pw]}")
  local_repos = client.get("/api/repositories", {'type' => 'local'})
  repos_to_clean = []
  local_repos.each do
  |repo|
    next unless repo['key'].start_with?("dev#{opts[:user]}")
    repos_to_clean << repo['key']
  end
  uris_to_delete = []
  repos_to_clean.each do
  |repo_name|
    storage = client.get("/api/storage/#{repo_name}")
    children = storage['children']
    children.each do
    |child|
      uris_to_delete << "#{artifactory_endpoint}/#{repo_name}#{child['uri']}"
    end
  end
  confirm = ask("About to delete: #{uris_to_delete}, ok, [Y/N] ") { |yn| yn.limit = 1, yn.validate = /[yn]/i }
  exit unless confirm.downcase == 'y'
  uris_to_delete.each do| uri |
    if !opts[:dry]
      puts "#{uri} will be deleted"
      client.delete("#{uri}")
      puts "done"
    else
      puts "dry run: #{uri} would be deleted"
    end

  end
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
  o.string '-u', '--user', 'User for Artifactory operations'
  o.string '-p', '--pw', 'Password for Artifactory operations'
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
INTERACTIVE_SUDO = InteractiveSudo.new(test_apps)
if !opts[:skipCacheClean]
  clean_caches(test_apps)
else
  puts "Skipping clean of Caches"
end
if !opts[:skipRunJobs]
  buildJobs(test_apps,opts)
else
  puts "Skipping Running of Build Jobs"
end
if !opts[:skipReposClean]
  clean_repos(test_apps, opts)
else
  puts "Skipping Running of Build Jobs"
end
if opts[:dry]
  puts "Dry run! No changes have been be made"
end
puts "Done."

