#!/usr/bin/env ruby
# encoding: utf-8
require_relative 'lib/jenkins'
require 'sshkit'
require 'sshkit/dsl'
include SSHKit::DSL
test_apps = Jenkins::TestApps.new
output = ""
on "#{test_apps.user}@#{test_apps.target}" do
  within "/var/jenkins/" do
    output = capture(:ls, '-l')
    end
end
puts output