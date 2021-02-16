#!/usr/bin/env ruby
# encoding: utf-8
require 'slop'
require 'yaml'
require 'fileutils'
require 'ostruct'
require 'apgsecrets'
require 'json'

def parse_show_plans_output(output,opts)
  plans_available = []
  if opts[:jsonOutput]
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
        plans_available << line
      end
    end
  end
  plans_available
end

def git_apg_clone(user, repo, target_dir)
  if  File.exist?(target_dir)
    FileUtils.remove_dir(target_dir, force = true)
  end
  gitcmd = "git clone #{user}@git.apgsga.ch:/var/git/repos/#{repo}  #{target_dir}"
  puts "Executeing : #{gitcmd} "
  system("#{gitcmd}")
  puts "Done."
end

opts = Slop.parse do |o|
  o.array '-i', '--install', 'Bolt installation plans to executed on the target host(s), , separated by <,>, the plan names can also match partially ', delimiter: ','
  o.bool '-sgc', '--skipGradleClone', 'Skip cloning of  gradle home git repository ', default: false
  o.bool '-shc', '--skipHieraClone', 'Skip cloning of hiera git repository ', default: false
  o.string '-u', '--user', 'SSH Sudo Username to access destination VM', required: true
  o.string '-t', '--target', 'One of the Puppet inventory Files predefined Target group names, which will be executed. Values: local,test and prod', default: 'local'
  o.separator ''
  o.separator 'other options:'
  o.bool '-l', '--list', 'List all Installation Bolt plans '
  o.bool '-a', '--all', 'Execute all Bolt plans'
  o.bool '-x', '--xceptJenkins', 'Execute all Bolt plans', default: false
  o.bool '--dry', '--dry-run','Only print all Bolt plans commands', default: false
  o.bool '--debug', 'Enable bolt debug optin', default: false
  o.bool '--jsonOutput', 'Bolt output format json', default: false
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
## Needs to run before jenkins account creations
plans_installation_order << OpenStruct.new('install_order' => 10, 'name' => 'piper::piper_service_account_create')
plans_installation_order << OpenStruct.new('install_order' => 11, 'name' => 'piper::jenkins_account_create')
plans_installation_order << OpenStruct.new('install_order' => 12, 'name' => 'piper::accounts_sshkeys')
plans_installation_order << OpenStruct.new('install_order' => 13, 'name' => 'piper::jenkins_dirs_create')
plans_installation_order << OpenStruct.new('install_order' => 20, 'name' => 'piper::jenkins_service_install')
plans_installation_order << OpenStruct.new('install_order' => 30, 'name' => 'piper::jenkins_create_jobs')
plans_installation_order << OpenStruct.new('install_order' => 40, 'name' => 'piper::piper_service_yum_repo')
plans_installation_order << OpenStruct.new('install_order' => 42, 'name' => 'piper::piper_service_install')
plans_installation_order << OpenStruct.new('install_order' => 43, 'name' => 'piper::piper_service_properties')
plans_installation_order << OpenStruct.new('install_order' => 44, 'name' => 'piper::apscli_remote_test_config')
plans_installation_order << OpenStruct.new('install_order' => 45, 'name' => 'piper::gradle_cred_setup')


plans_to_execute = []
show_output = `bolt plan show`
plans_available = parse_show_plans_output(show_output,opts)
if !targets.include?(opts[:target])
  puts "Invalid target group name : #{opts[:target]}, please enter one of : #{targets.to_s} "
  puts opts
  exit
end
puts "Running target group with name : #{opts[:target]} "
secrets = Secrets::Store.new("Patschserversetup-#{opts[:target]}",opts[:target] == 'local' ? 86400 : 7200)
secrets.prompt_and_save(opts[:user], "Please enter pw for user: #{opts[:user]} on targets: #{opts[:target]} and hit return:")
if !opts[:skipClone]
  git_apg_clone(opts[:user], "apg-gradle-properties.git", "downloads/gradlehome")
end
git_apg_clone(opts[:user],"patchserver-setup-hiera","downloads/hiera")
if !opts[:install].empty? and (opts[:all] or  opts[:xceptJenkins])
  puts 'Specify either  -a or -x  or -i option, a being all plans, x plans independent of jenkins, i specific plans'
  puts opts
  exit
end
if opts[:all] and opts[:xceptJenkins]
  puts 'Choose either the a or x option , a being all plans , x plans which are the pre condition for the jenkins plans'
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
if opts[:install].empty? and !opts[:all] and !opts[:xceptJenkins]
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
  plans_available.delete('pipertest::clean_repo')
  plans_to_execute = plans_available
end

def run(plan,opts,secrets,parm)
  debug = opts[:debug] ? '--debug' : ' '
  cmd = "bolt plan run #{plan} #{debug} --user #{opts[:user]} --password xxxxxx --targets #{opts[:target]} #{parm}"
  puts "#{cmd}"
  cmd_to_execute = cmd.sub('xxxxxx', secrets.retrieve(opts[:user]))
  system(cmd_to_execute) unless opts[:dry]
  puts "Done: #{plan}"  unless opts[:dry]
end

if opts[:xceptJenkins]
  plans_to_execute = plans_pre_jenkins
end

unless plans_to_execute.empty?
  sorted_plans = plans_installation_order.sort_by {|p| [p.install_order]}
  sorted_plans.each do |plan|
    if plans_to_execute.include? plan.name
      parm = plans_with_user_param.include?(plan.name) ? " user=#{opts[:user]} " : ""
      run(plan.name,opts,secrets,parm)
    end
  end

end

