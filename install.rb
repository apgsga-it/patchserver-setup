#!/usr/bin/env ruby
# encoding: utf-8
require "slop"
require "ipaddress"

opts = Slop.parse do |o|
  o.string '-u', '--username', '--user', 'Target(s) host user'
  o.string '-p', '--password', '--pw', 'Target(s) host user password'
  o.string '-t', '--target', '--host', 'Target host(s) '
  o.array '-i', '--install', 'Bolt installation plans to executed on the target host(s), , separated by <,>, the plan names can also match partially ', delimiter: ","
  o.separator ''
  o.separator 'other options:'
  o.bool '-l', '--list', 'List all Installation Bolt plans ', default: false
  o.bool '-a', '--all', 'Execute all Bolt plans', default: false
  o.bool '--dry', 'Only print all Bolt plans commands', default: false
  o.bool '--debug', 'Enable bolt debug optin', default: false
  o.on '-h', '--help' do
    puts o
    exit
  end
end


show_output = `bolt plan show`
plans_available = []
lines = show_output.split("\n")
lines.each do |line|
  if (line.match(/piper::/))
    plans_available << line
  end
end
if !opts[:username] or !(opts[:password] or !opts[:target]) and (opts[:plans] or opts[:all])
  puts "Missing options <username>, <password> and/or <target> to execute Bolt plan  "
  puts opts
  exit
end
if !opts[:install].empty? and opts[:all]
  puts "Specify either  -a  or -i option, but not both. -a being all plans and -i being a filter on the available plan names "
  puts opts
  exit
end
if !IPAddress.valid? opts[:target]
  puts "Ipaddress not valid: #{opts[:target]}, you can do better "
  puts opts
  exit
end
if opts[:list]
  puts "Available installations plans are : #{plans_available}"
end
if !opts[:install].empty?
  plans = []
  opts[:install].each do |plan|
    plans << plans_available.find { |e| e =~ /#{plan}/ } if plans_available.find { |e| e =~ /#{plan}/ }
  end
  plans_available = plans
end

def run(plan,opts)
  debug = opts[:debug] ? "--debug" : " "
  cmd = "bolt plan run #{plan} #{debug} --targets=#{opts[:target]} -u #{opts[:user]} -p #{opts[:password]}"
  puts "About to run bolt command: #{cmd}"
  system(cmd) unless opts[:dry]
  puts "Done: #{plan}"
end


if opts[:plans] or opts[:all]
  puts "Running with user=<#{opts[:user]}> the plans=<#{plans_available}> on target:#{opts[:target]}"
  if plans_available.include? 'piper::java_install'
    run('piper::java_install',opts)
    plans_available.delete('piper::java_install')
  end
  if plans_available.include? 'piper::ruby_install'
    run('piper::ruby_install',opts)
    plans_available.delete('piper::ruby_install')
  end
  plans_available.each do |plan|
    run(plan,opts)
  end
end

