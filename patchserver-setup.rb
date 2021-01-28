#!/usr/bin/env ruby
# encoding: utf-8
require 'slop'
require 'yaml'
require 'fileutils'
require 'ostruct'

opts = Slop.parse do |o|
  o.array '-i', '--install', 'Bolt installation plans to executed on the target host(s), , separated by <,>, the plan names can also match partially ', delimiter: ','
  o.bool '-s', '--skipClone', 'Skip cloning of  gradle home locally ', default: false
  o.string '-u', '--user', 'SSH Username to access destination VM', required: true
  o.string '-t', '--target', 'Target group and host (separated by comma) on which bolt plan will be executed. Parameter example (test->group,test.apgsga.ch->target): test,test.apgsga.ch  ', required: true
  o.separator ''
  o.separator 'other options:'
  o.bool '-l', '--list', 'List all Installation Bolt plans '
  o.bool '-a', '--all', 'Execute all Bolt plans'
  o.bool '-x', '--xceptJenkins', 'Execute all Bolt plans', default: false
  o.bool '--dry', '--dry-run','Only print all Bolt plans commands', default: false
  o.bool '--debug', 'Enable bolt debug optin', default: false
  o.on '-h', '--help' do
    puts o
    exit
  end
end
show_output = `bolt plan show --concurrency 20 `
plans_installation_order = []
plans_installation_order << OpenStruct.new('install_order' => 1, 'name' => 'piper::cvs_install')
plans_installation_order << OpenStruct.new('install_order' => 1, 'name' => 'piper::git_install')
plans_installation_order << OpenStruct.new('install_order' => 1, 'name' => 'piper::wget_install')
plans_installation_order << OpenStruct.new('install_order' => 1, 'name' => 'piper::java_install')
plans_installation_order << OpenStruct.new('install_order' => 2, 'name' => 'piper::gradle_install')
plans_installation_order << OpenStruct.new('install_order' => 2, 'name' => 'piper::maven_install')
## Needs to run before jenkins account creations
plans_installation_order << OpenStruct.new('install_order' => 10, 'name' => 'piper::piper_service_account_create')
plans_installation_order << OpenStruct.new('install_order' => 11, 'name' => 'piper::jenkins_account_create')
plans_installation_order << OpenStruct.new('install_order' => 12, 'name' => 'piper::jenkins_dirs_create')
plans_installation_order << OpenStruct.new('install_order' => 20, 'name' => 'piper::jenkins_service_install')
plans_installation_order << OpenStruct.new('install_order' => 30, 'name' => 'piper::jenkins_create_jobs')
plans_installation_order << OpenStruct.new('install_order' => 40, 'name' => 'piper::piper_service_yum_repo')
plans_installation_order << OpenStruct.new('install_order' => 42, 'name' => 'piper::piper_service_install')
plans_installation_order << OpenStruct.new('install_order' => 43, 'name' => 'piper::piper_service_properties')

plans_available = []
plans_to_execute = []
lines = show_output.split("\n")
lines.each do |line|
  if line.match(/piper::/)
    plans_available << line
  end
end
if !opts[:skipClone]
  bolt_inventory_file = File.join(File.dirname(__FILE__), 'inventory.yaml')
  inventory = YAML.load_file(bolt_inventory_file)
  temp_dir = inventory['vars']['temp_gradle']
  if  File.exist?(temp_dir)
    FileUtils.remove_dir(temp_dir, force = true)
  end
  # TODO JHE : git user, currently hardcoded with jhe -> IT-36770 and IT-36776
  system("git clone jhe@git.apgsga.ch:/var/git/repos/apg-gradle-properties.git #{temp_dir}")
end
if !opts[:install].empty? and opts[:all]
  puts 'Specify either  -a  or -i option, but not both. -a being all plans and -i being a filter on the available plan names '
  puts opts
  exit
end
if !opts[:all] and opts[:xceptJenkins]
  puts 'The x , resp. xceptJenkins option only makes sense with the --all options'
  puts opts
  exit
end
if opts[:list]
  puts 'Available installations plans are: '
  plans_available.each do
    | plan | puts plan
  end
  puts 'The ordering of the plan execution will be respected with the --all option'
  puts 'With the -i option, the order of the input defines the execution order of the plans'
end
if opts[:install].empty? and !opts[:all]
  exit
end

unless opts[:install].empty?
  plans = []
  opts[:install].each do |plan|
    plans += plans_available.select { |e| e =~ /#{plan}/  }
  end
  plans_to_execute = plans
end

def run(plan,opts)
  debug = opts[:debug] ? '--debug' : ' '
  cmd = "bolt plan run #{plan} #{debug} --concurrency 10 --user #{opts[:user]} --targets #{opts[:target]} --password-prompt"
  puts "#{cmd}"
  system(cmd) unless opts[:dry]
  puts "Done: #{plan}"  unless opts[:dry]
end

if opts[:all]
  plans_available.delete('pipertest::clean_repo')
  plans_to_execute = plans_available
end


unless plans_to_execute.empty?
  if opts[:xceptJenkins]
    plans_to_execute.delete('piper::jenkins_service_install')
    plans_to_execute.delete('piper::jenkins_account_create')
    plans_to_execute.delete('piper::jenkins_dirs_create')
    plans_to_execute.delete('piper::piper_service_install')
    plans_to_execute.delete('piper::piper_service_account_create')
    plans_to_execute.delete('piper::piper_service_properties')
    plans_to_execute.delete('piper::jenkins_create_jobs')
  end
  sorted_plans = plans_installation_order.sort_by {|p| [p.install_order]}
  sorted_plans.each do |plan|
    if plans_to_execute.include? plan.name
      run(plan.name,opts)
    end
  end

end

