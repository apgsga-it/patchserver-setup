#!/usr/bin/env ruby
# encoding: utf-8
require 'slop'
require 'yaml'
require 'fileutils'
require 'ostruct'
require 'apgsecrets'
require 'tty-spinner'
require 'tempfile'

def parse_show_plans_output(output,opts)
  plans_available = []
  if opts[:jsonOutput]
    require 'json'
    show_plans = JSON.parse(output)
    show_plans['plans'].each do |plan|
      if plan.first.start_with?("piper")
        plans_available << plan.first
      end
    end
  else
    lines = output.split("\n")
    lines.each do |line|
      if line.match(/piper::/)
        plans_available << line.strip
      end
    end
  end
  plans_available
end

TEMP_DIR_SETUP = "/tmp/patchserver-setup"

def create_new_temp_dir(opts)
  puts "Creating new tempory directory #{TEMP_DIR_SETUP}"
  if opts[:dry]
    "Nope , doing nothing, dry run"
    return
  end
  if  File.exist?(TEMP_DIR_SETUP)
    FileUtils.remove_dir(TEMP_DIR_SETUP, force = true)
  end
  FileUtils.mkdir_p(TEMP_DIR_SETUP)
  puts "Done."
end

def git_apg_clone(opts, repo, target_dir, branch = nil )
  if branch
    gitcmd = "git clone -b #{branch}  --single-branch #{opts[:user]}@git.apgsga.ch:/var/git/repos/#{repo}  #{TEMP_DIR_SETUP}/#{target_dir}"
  else
    gitcmd = "git clone #{opts[:user]}@git.apgsga.ch:/var/git/repos/#{repo}  #{TEMP_DIR_SETUP}/#{target_dir}"
  end

  puts "Executeing : #{gitcmd} "
  if opts[:dry]
    "Nope , doing nothing, dry run"
    return
  end
  system("#{gitcmd}")
  puts "Done."
end


def run(plan,opts,secrets,parm)
  debug = opts[:debug] ? '--debug' : ' '
  cmd = "bolt plan run #{plan} #{debug} --user #{opts[:user]} --password xxxxxx --targets #{opts[:target]} #{parm}"
  puts "#{cmd}"
  cmd_to_execute = cmd.sub('xxxxxx', secrets.retrieve(opts[:user]))
  system(cmd_to_execute) unless opts[:dry]
  puts "Done: #{plan}"  unless opts[:dry]
end


opts = Slop.parse do |o|
  o.string '-u', '--user', 'SSH Sudo Username to access destination VM', required: true
  o.string '-t', '--target', 'One of the Puppet inventory Files predefined Target group names, which will be executed. Values: local,test and prod. Defaults to local', default: 'local'
  o.bool '-a', '--all', 'Execute all Bolt plans'
  o.bool '-x', '--xceptJenkins', 'Execute Plans only, which are pre-condition for the Piper related plans ', default: false
  o.bool '-aa', '--allPiper', 'Execute Plans only, which are related to Piper und the Jenkins Installation ', default: false
  o.array '-i', '--install', 'Bolt installation plans to executed on the target host(s), , separated by <,>, the plan names can also match partially ', delimiter: ','
  o.separator ''
  o.separator 'other options:'
  o.bool '-l', '--list', 'List all available Puppet plans '
  o.bool '--dry', '--dry-run','Only print all Bolt plans commands', default: false
  o.bool '-sgc', '--skipGradleClone', 'Skip cloning of  gradle home git repository into downloads ', default: false
  o.bool '-shc', '--skipHieraClone', 'Skip cloning of hiera git repository into downloads', default: false
  o.bool '--debug', 'Enable bolt debug option', default: false
  o.bool '--jsonOutput', 'Bolt output format json, instead of rainbow', default: false
  o.on '-h', '--help' do
    puts o
    exit
  end
end
targets = %w[local test prod]
plans_pre_jenkins = []
plans_pre_jenkins << 'piper::cvs_install'
plans_pre_jenkins << 'piper::git_install'
plans_pre_jenkins << 'piper::wget_install'
plans_pre_jenkins << 'piper::java_install'
plans_pre_jenkins << 'piper::gradle_install'
plans_pre_jenkins << 'piper::maven_install'
plans_with_user_param = []
plans_with_user_param << 'piper::jenkins_create_jobs'
plans_with_user_param << 'piper::jenkins_dirs_create'
plans_with_user_param << 'piper::piper_service_properties'
plans_installation_order = []
plans_installation_order << OpenStruct.new('install_order' => 1, 'name' => 'piper::cvs_install')
plans_installation_order << OpenStruct.new('install_order' => 1, 'name' => 'piper::git_install')
plans_installation_order << OpenStruct.new('install_order' => 1, 'name' => 'piper::wget_install')
plans_installation_order << OpenStruct.new('install_order' => 1, 'name' => 'piper::java_install')
plans_installation_order << OpenStruct.new('install_order' => 2, 'name' => 'piper::gradle_install')
plans_installation_order << OpenStruct.new('install_order' => 2, 'name' => 'piper::maven_install')
plans_installation_order << OpenStruct.new('install_order' => 2, 'name' => 'piper::ruby_install')

## Needs to run before jenkins account creations
plans_installation_order << OpenStruct.new('install_order' => 10, 'name' => 'piper::local_accounts_create')
plans_installation_order << OpenStruct.new('install_order' => 13, 'name' => 'piper::jenkins_dirs_create')
plans_installation_order << OpenStruct.new('install_order' => 20, 'name' => 'piper::jenkins_service_install')
plans_installation_order << OpenStruct.new('install_order' => 30, 'name' => 'piper::jenkins_create_jobs')
plans_installation_order << OpenStruct.new('install_order' => 40, 'name' => 'piper::piper_service_yum_repo')
plans_installation_order << OpenStruct.new('install_order' => 42, 'name' => 'piper::piper_service_install')
plans_installation_order << OpenStruct.new('install_order' => 43, 'name' => 'piper::piper_service_properties')
plans_installation_order << OpenStruct.new('install_order' => 44, 'name' => 'piper::apscli_remote_test_config')
plans_installation_order << OpenStruct.new('install_order' => 45, 'name' => 'piper::gradle_cred_setup')


plans_to_execute = []
puts "Running target group with name : #{opts[:target]} "
secrets = Secrets::Store.new("Patschserversetup-#{opts[:target]}",opts[:target] == 'local' ? 86400 : 7200)
secrets.prompt_and_save(opts[:user], "Please enter pw for user: #{opts[:user]} on targets: #{opts[:target]} and hit return:    ")
puts "\nRecieved password, password wasn't validated, login may fail later with the Execution of the Plans (closed stream)"
spinner = TTY::Spinner.new("[:spinner] :title",format: 'classic', hide_cursor: true)
spinner.update(title: 'Loading available Piper Puppet Plans...')
spinner.auto_spin
temp_file = Tempfile.new
pid = spawn("bolt plan show > #{temp_file.path}")
spinner.run "Done." do
  Process.wait pid
end
plans_available = parse_show_plans_output(File.read(temp_file.path),opts)
if !targets.include?(opts[:target])
  puts "Invalid target group name : #{opts[:target]}, please enter one of : #{targets.to_s} "
  puts opts
  exit
end
create_new_temp_dir(opts)
if !opts[:skipGradleClone]
  git_apg_clone(opts, "apg-gradle-properties.git", "gradlehome")
end
if !opts[:skipHieraClone]
  git_apg_clone(opts,"patchserver-setup-hiera","hiera")
end
if !opts[:install].empty? and (opts[:all] or  opts[:xceptJenkins]  or opts[:allPiper])
  puts 'Specify either  -a, -x , -aa or -i option'
  puts opts
  exit
end
if opts[:all] and (opts[:xceptJenkins] or opts[:allPiper])
  puts 'Choose either the -a, -x or -aa option'
  puts opts
  exit
end
if opts[:list]
  puts 'Available installations plans are: '
  plans_available.each do
    | plan | puts plan
  end
  puts 'The ordering of the plan execution will be respected with the -a, -x or -aa option'
  puts 'With the -i option, the order of the input defines the execution order of the plans'
end
if opts[:install].empty? and !opts[:all] and !opts[:xceptJenkins] and !opts[:allPiper]
  exit
end

unless opts[:install].empty?
  plans = []
  opts[:install].each do |plan|
    plans += plans_available.select { |e| e =~ /#{plan}/  }
  end
  plans_to_execute = plans
end

if opts[:all]
  plans_to_execute = plans_available
end

if opts[:allPiper]
  plans_to_execute = plans_available - plans_pre_jenkins
end

if opts[:xceptJenkins]
  plans_to_execute = plans_pre_jenkins
end


unless plans_to_execute.empty?
  sorted_plans = plans_installation_order.sort_by {|p| [p.install_order]}
  puts "The following plans will be executed in the order as listed: "
  sorted_plans.each do |plan|
    if plans_to_execute.include? plan.name
      puts "#{plan.name}"
    end
  end
  puts "Running plans, dry: #{opts[:dry]}"
  sorted_plans.each do |plan|
    if plans_to_execute.include? plan.name
      parm = plans_with_user_param.include?(plan.name) ? " user=#{opts[:user]} " : ""
      run(plan.name,opts,secrets,parm)
    end
  end
  puts "Running plans, dry: #{opts[:dry]} done."
end

