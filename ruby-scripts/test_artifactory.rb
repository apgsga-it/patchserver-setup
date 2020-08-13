#!/usr/bin/env ruby
# encoding: utf-8
#
require_relative 'lib/artifactory'
require 'highline/import'
password = ask("Enter password: ") { |q| q.echo = false }
command = Artifactory::Cli.new('artifactory4t4apgsga.jfrog.io/artifactory', 'che', password, dry_run = false)
maven_profile = 'artifactory-che'
maven_profile.index('-')
user_filter = maven_profile[maven_profile.index('-')+1..-1]
puts user_filter
command.clean_repositories(command.list_repositories(user_filter), true)