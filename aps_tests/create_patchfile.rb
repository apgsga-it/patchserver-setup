#!/usr/bin/env ruby
# encoding: utf-8
require 'slop'
require_relative 'data/test_cases'
opts = Slop.parse do |o|
  o.string '-t', '--testcase', 'Testcase name , see data/test_cases or the list option'
  o.bool '-l', '--list', 'List all the known testcases ', default: false
  o.string '-n', '--patchNumber', 'Patchnummer to be generated', default: "1"
  o.string '-f', '--patchFile', 'Patch filename to written, default Patch<patchnumber>'
  o.boolean '-p', '--print', 'Print Patchfile content', default: false
  o.boolean '-x', '--skipWrite', 'Skip write Patchfile', default: false
  o.on '-h', '--help' do
    puts o
    exit
  end
end
patchBuilder = TestCases::PatchBuilder.new
if opts[:list]
  puts patchBuilder.list.to_s
end
if opts[:testcase]
  result = patchBuilder.make(opts[:testcase],opts[:patchNumber])
  if !result
    puts opts
    exit
  end
  patch_file_name = "Patch#{opts[:patchNumber]}.json"
  if opts[:patchFile]
    patch_file_name = opts[:patchFile]
  end
  if !opts[:x]
    Aps::Api::asJsonFile(result,patch_file_name)
    puts "Patchfile generated to #{patch_file_name}"
  end
  if opts[:print]
    puts Aps::Api.asJsonString(result)
  end
end
