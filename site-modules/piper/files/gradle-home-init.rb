#!/usr/bin/env ruby
# encoding: utf-8
require "slop"
require "ipaddress"
require 'nokogiri'
require 'fileutils'

def help(o)
  puts "This script sets up the Gradle Home directory according to Apg stanards. \n" +
           "The setup should generally facilitat the interoperabililty between Gradle and Maven\n" +
           "It clones a git repository contianing a initai setup as basis and allows configuration as options:\n" +
           " -  set the Profile according to the MAven settings.xml file used\n" +
           " -  set the mavenLocalRepo for Gradle according to the Maven settings.xml\n" +
           " -  copies and adapts a settings.xml\n"

  puts "\n"
  puts o
end

opts = Slop.parse do |o|
  o.string '-m', '--mvnSettingsParentDir', 'Directory which contains the Maven setting.xml. Default $HOME/.m2', default: "#{ENV['HOME']}/.m2"
  o.string '-p', '--mvnProfile', 'Maven Profile from settings.xml to be set. Default: artifactory', default: "arteactory"
  o.string '-r', '--mvnLocalRepo', 'Maven Local Repository. Default $HOME/.m2/repository', default: "#{ENV['HOME']}/.m2/repository"
  o.string '-g', '--gitRepo', 'Git Repo for the Apg Gradle Home setup. Default: git.apgsga.ch:/var/git/repos/apg-gradle-properties.git', default: "git.apgsga.ch:/var/git/repos/apg-gradle-properties.git"
  o.string '-t', '--targetDir', 'Target Directory for the git clone of the gitRepo ', default: "/tmp/gradlehome"


  o.separator ''
  o.separator 'other options:'
  o.bool '-l', '--mvmProfileList', 'List available Profile from settings.xml'
  o.bool '-x', '--printSettingsXml', "Print Settings Xml Template"
  o.string '-b', '--gitBranch', "Branch to be cloned of the git repo"
  o.bool '-d', '--deleteTarget', "Delete the target Directory for the clone"
  o.bool '-s', '--skipClone', "Skip the git clone, mainly for testing purposes"
  o.on '-h', '--help' do
    help(o)
    exit
  end
end
puts "The Apg Gradle Home Git Repo will be cloned from:  #{opts[:gitRepo]} and to:  #{opts[:targetDir]}"
puts "and configured Using as Maven Settings Parent Diretory:  #{opts[:mvnSettingsParentDir]} and the Profile:  #{opts[:mvnProfile]}"
puts "The mavenLocal Repository Path is set to  #{opts[:mvnSettingsParentDir]} "
# TODO (che, 25.6) : support branch
#
# Copy Git Repo to Target
if (opts[:deleteTarget] and !opts[:skipClone])
  FileUtils.rm_rf opts[:targetDir], verbose: true
end
gitcmd = "git clone #{opts[:gitRepo]} #{opts[:targetDir]}"
puts "About to execute #{gitcmd}"
system gitcmd unless opts[:skipClone]
puts "done."
# Checking preconditions
doc = Nokogiri::XML(File.open("#{opts[:targetDir]}/settings.xml.template"))
if (opts[:printSettingsXml])
  puts "Settings XML Template:"
  puts doc
end
profiles = []
doc.xpath("//profile/id").each do |n|
  profiles << n.content
end
if (opts[:mvmProfileList])
  puts "Available profiles:"
  puts profiles
end
errors = false
profiles
if (!profiles.include? opts[:mvnProfile])
  puts "#{opts[:mvnProfile]} not a valid maven Profile, available profiles: "
  puts   puts profiles
  errors = true
end
if (!File.exist? (opts[:mvnSettingsParentDir]) or !File.directory? (opts[:mvnSettingsParentDir]) or !File.writable? (opts[:mvnSettingsParentDir]))
  puts "Settings Parent Dir #{opts[:mvnSettingsParentDir]} is not valid: either not a directory or not writable or doesn't exist "
  errors = true
end
if (!File.exist? (opts[:mvnLocalRepo]) or !File.directory? (opts[:mvnLocalRepo]) or !File.writable? (opts[:mvnLocalRepo]))
  puts "Maven Local Dir #{opts[:mvnLocalRepo]} is not valid: either not a directory or not writable or doesn't exist "
  errors = true
end
if errors
  puts "Error(s) ocurred , exiting......."
end
# Invoke iniGradleProfle script
# TODO (jhe, 25.8) : Missing Mavenlocal Repo Option
cmd = "./initGradleProfile.sh #{opts[:mvnSettingsParentDir]} #{opts[:mvnProfile]} copySettingsXml"
puts "Running #{cmd}"
Dir.chdir("#{opts[:targetDir]}") do
  system (cmd)
end

puts "Done."