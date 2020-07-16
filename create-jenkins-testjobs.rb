#!/usr/bin/env ruby
# encoding: utf-8
require "slop"
require 'erb'
require 'yaml'
require 'tmpdir'

def help(opts)
  puts "This script creates maven build jobs for a piper test modules defined in the inventory.yaml file in jenkins running on the target host \n\n" +
           "Preconditions: \n" +
           "- Jenkins is running on the Target host and ssh access works for the Jenkins Cli\n" +
           "- The test module needs to be in the apg-gradle-plugins-testsmodules module of cvs.apgsga.ch\n\n" +
  "It reads the inventory.yaml file and looks there for the respective paramaters of the installation\n\n"
      puts opts
end

opts = Slop.parse do |o|
  o.string '-t', '--target', 'The target host, where jenkins is running'
  o.string '-u', '--user', 'User for the target host , where jenkins is running'
  o.bool '-y', '--dry', 'Dry run, without invoking Jenkins cli via ssh', default: false
  o.bool '-d', '--delete', 'Delete the jobs, before creating', default: false
  o.on '-h', '--help' do
    help(o)
    exit
  end
end

# Preconditions
if (!opts[:target] or !opts[:user])
  puts "Target Host and / or User option is missing \n"
  puts opts
  exit
end
bolt_inventory_file = File.join(File.dirname(__FILE__), "inventory.yaml")
if (!File.exist?(bolt_inventory_file) or !File.readable?(bolt_inventory_file))
  puts "The necessary puppet/bolt inventory.yaml file does not exist or is not readable, exiting"
  exit(1)
end
template_file = File.join(File.dirname(__FILE__), "site-modules/piper/templates/maven-job-config.xml.erb")
if (!File.exist?(template_file) or !File.readable?(template_file))
  puts "The necessary erb job template File site-modules/piper/templates/maven-job-config.xml.erb does not exist, exiting"
  exit(1)
end

inventory = YAML.load_file(bolt_inventory_file)
modules_config = inventory["vars"]["testapp_modules"]
if !modules_config
  puts "Testapp Modules not configured in inventory.yaml, exiting"
  puts inventory.to_yaml
  exit(1)
end

mavenjob_template_text = File.read(template_file)
if opts[:dry]
  puts "Dry run! No changes will be made"
end
modules = modules_config.split(" ")
tempDir = Dir.mktmpdir("jenkins")
renderer = ERB.new(mavenjob_template_text)
modules.each do | mod |
  @module_name = mod
  output = renderer.result()
  job_name_parts = @module_name.split("-")
  job_name = ""
  job_name_parts.each do | part |  job_name += part.capitalize()  end
  puts "Jobname : #{job_name}"
  job_xml_file = File.join(tempDir, "#{job_name}.xml")
  File.write(job_xml_file, output)
  if opts[:delete]
    cmd = "ssh -l #{opts[:user]} -p 53801 #{opts[:target]} delete-job #{job_name} "
    puts "Deleteing Job first: #{cmd} "
    if !opts[:dry]
      system(cmd)
      puts "Job deletec in Jenkins"
    end
  end
  cmd = "cat #{job_xml_file} | ssh -l #{opts[:user]} -p 53801 #{opts[:target]} create-job #{job_name} "
  puts "Running: #{cmd} "
  if !opts[:dry]
    system(cmd)
    puts "Job created in Jenkins"
  end
end
# TODO (che, 17.7 ) integrate into inventory.xml
if opts[:delete]
  cmd = "ssh -l #{opts[:user]} -p 53801 #{opts[:target]} delete-job TestAppPkg"
  puts "Running: #{cmd} "
  system(cmd)
  puts "Deleted TestappPkg Job in Jenkins"
end
pkgJob = File.join(File.dirname(__FILE__), "site-modules/piper/templates/gradle-job-config.xml.erb")
cmd =  "cat #{pkgJob} | ssh -l #{opts[:user]} -p 53801 #{opts[:target]} create-job TestAppPkg"
puts "Running: #{cmd} "
if !opts[:dry]
  system(cmd)
end
puts "Created TestappPkg Job in Jenkins"
puts "Done Writing Job Xml Files to #{tempDir}"



