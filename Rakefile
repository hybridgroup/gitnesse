#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'
require_relative 'lib/gitnesse'

Rake::TestTask.new do |t|
  t.libs << 'lib/gitnesse'
  t.test_files = FileList['test/lib/gitnesse/*_test.rb']
  t.verbose = true
end
task :default => :test

namespace :gitnesse do
  desc "Push local features to remote git-based wiki."
  task :push do
    Gitnesse.load_config
    Gitnesse.push
  end

  desc "Pull remote features from git-based wiki to local."
  task :pull do
    Gitnesse.load_config
    Gitnesse.pull
  end

  desc "Dump the current config info to the console."
  task :info do
    puts Gitnesse.config_to_hash.to_yaml
  end
end
