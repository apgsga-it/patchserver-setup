#!/usr/bin/env ruby
# encoding: utf-8
require "slop"
require 'sshkit'
require 'sshkit/dsl'
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
SSHKit::Backend::Netssh.config.pty = 1
on "#{test_apps.user}@#{test_apps.target}" do
  within "#{test_apps.gradle_home}/home" do
    execute(:sudo, :rm, '-Rf caches/*', :interaction_handler => INTERACTIVE_SUDO)
  end
  within "#{test_apps.maven_home}" do
    execute(:sudo, :rm, '-Rf *', :interaction_handler => INTERACTIVE_SUDO)
  end
end
# Starting and executing all Test Builds sequentially ana waiting on their output
test_apps.accept(TestAppsJobBuilder.new(opts))
if opts[:dry]
  puts "Dry run! No changes have been be made"
end
puts "Done."

