#!/usr/bin/env ruby
# encoding: utf-8
require "slop"
require_relative 'lib/jenkins'

class TestAppsJobCreator < Jenkins::BaseVisitor
  attr_reader :opts, :mavenRenderer
  def initialize(opts)
    @opts = opts
  end
  def visit_TestApps(subject)
    puts "Generation Jenkings Jobs for TestApps"
  end
  def visit_TestApp(subject)
    @mavenRenderer = Jenkins::Renderer.new("maven-job-config.xml.erb")
  end
  def visit_MavenModule(subject)
    result = @mavenRenderer.render(subject.name, subject.root_dir)
    if @opts[:delete]
      Jenkins::DeleteJob.new(subject.target,subject.user,result[:job_name],@opts[:dry]).run
    end
    Jenkins::CreateJob.new(subject.target,subject.user,result[:job_name], result[:job_xml_file],@opts[:dry]).run
  end
  def visit_PkgModule(subject)
    renderer = Jenkins::Renderer.new("gradle-job-config.xml.erb")
    result = renderer.render(subject.name, subject.root_dir)
    if @opts[:delete]
      Jenkins::DeleteJob.new(subject.target,subject.user,result[:job_name],@opts[:dry]).run
    end
    Jenkins::CreateJob.new(subject.target,subject.user,result[:job_name], result[:job_xml_file],opts[:dry]).run
  end
end

def help(opts)
  puts "This script creates build jobs for a piper test modules defined in the inventory.yaml file in jenkins running on the target host \n\n" +
           "Preconditions: \n" +
           "- Jenkins is running on the Target host and ssh access works for the Jenkins Cli\n" +
           "- The test modules needs to be in cvs.apgsga.ch\n\n" +
           "It reads the inventory.yaml file and looks there for the respective paramaters of the installation\n\n"
  puts opts
end

opts = Slop.parse do |o|
  o.bool '-y', '--dry', 'Dry run, without invoking Jenkins cli via ssh', default: false
  o.bool '-d', '--delete', 'Delete the jobs, before creating', default: false
  o.on '-h', '--help' do
    help(o)
    exit
  end
end
if opts[:dry]
  puts "Dry run! No changes will be made"
end
test_apps = Jenkins::TestApps.new
test_apps.accept(TestAppsJobCreator.new(opts))
if opts[:dry]
  puts "Dry run! No changes have been be made"
end
puts "Done."

