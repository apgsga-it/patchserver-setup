#!/usr/bin/env ruby
# encoding: utf-8
require "slop"
require_relative 'lib/jenkins'

class TestAppsJobDeleter < Jenkins::BaseVisitor
  include Jenkins
  attr_reader :opts
  def initialize(opts)
    @opts = opts
  end
  def visit_TestApps(subject)
    puts "Deleting Jenkins Jobs for TestApps"
  end
  def visit_MavenModule(subject)
    Jenkins::DeleteJob.new(subject.target,subject.user,job_name(subject.name),@opts[:dry]).run
  end
  def visit_PkgModule(subject)
    Jenkins::DeleteJob.new(subject.target,subject.user,job_name(subject.name),@opts[:dry]).run
  end
end

def help(opts)
  puts "This script deletes the Jenkins Jobs for the Testapps defined in inventory.yaml file in Jenkins running on the target host \n\n" +
           "Preconditions: \n" +
           "- Jenkins is running on the Target host and ssh access works for the Jenkins Cli\n" +
           "- Jobs exist in Jenkins\n\n" +
           "It reads the inventory.yaml file and looks there for the respective paramaters of the installation\n\n"
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
test_apps = Jenkins::TestApps.new
test_apps.accept(TestAppsJobDeleter.new(opts))
if opts[:dry]
  puts "Dry run! No changes have been be made"
end
puts "Done."

