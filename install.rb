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
  o.bool '-x', '--xceptJenkins', 'Execute all Bolt plans', default: false
  o.bool '--dry', '--dry-run','Only print all Bolt plans commands', default: false
  o.bool '--debug', 'Enable bolt debug optin', default: false
  o.on '-h', '--help' do
    puts o
    exit
  end
end


show_output = `bolt plan show`
plans_available = []
plans_to_execute = []
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
if !opts[:all] and opts[:xceptJenkins]
  puts "The x , resp. xceptJenkins option only makes sense with the --all options"
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
    plans += plans_available.select { |e| e =~ /#{plan}/  }
  end
  plans_to_execute = plans
end

def run(plan,opts)
  debug = opts[:debug] ? "--debug" : " "
  cmd = "bolt plan run #{plan} #{debug} --targets=#{opts[:target]} -u #{opts[:user]} -p #{opts[:password]}"
  puts "#{cmd}"
  system(cmd) unless opts[:dry]
  puts "Done: #{plan}"  unless opts[:dry]
end

if opts[:all]
  plans_to_execute = plans_available
end


if !plans_to_execute.empty?
  puts "Running with user=<#{opts[:user]}> the plans=<#{plans_to_execute}> on target:#{opts[:target]}"
  plans_after = []
  if opts[:xceptJenkins]
    plans_to_execute.delete('piper::jenkins_install')
  end
  if plans_to_execute.include? 'piper::java_install'
    run('piper::java_install',opts)
    plans_to_execute.delete('piper::java_install')
  end
  if plans_to_execute.include? 'piper::ruby_install'
    run('piper::ruby_install',opts)
  end
  if plans_to_execute.include? 'piper::jenkins_install'
    plans_after = %w[piper::jenkins_install]
    plans_to_execute.delete('piper::jenkins_install')
  end
  plans_to_execute.each do |plan|
    run(plan,opts)
  end
  plans_after.each do |plan|
    run(plan,opts)
  end
end

