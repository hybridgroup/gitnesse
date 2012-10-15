require 'bundler/setup'
require 'fileutils'
require 'tmpdir'
require 'gitnesse/railtie' if defined?(Rails::Railtie)

module Gitnesse

  def self.repository_url
    @@repository_url
  end

  def self.repository_url=(repository_url)
    @@repository_url = repository_url
  end

  def self.branch
    @@branch ||= "master"
  end

  def self.branch=(branch)
    @@branch = branch
  end

  def self.target_directory
    @@target_directory ||= File.join(Dir.pwd, 'features')
  end

  def self.target_directory=(target_directory)
    @@target_directory = target_directory
  end

  def self.config
    yield self
  end

  def perform
    %w(git cucumber).each do |cmd|
      output=`#{cmd} --version 2>&1`; requirement_ok=$?.success?
      abort("#{cmd} command not found or not working.") unless requirement_ok
    end

    abort("Setup git URL for Gitnesse.") if Gitnesse.repository_url.nil?

    puts "Loading features into: #{Gitnesse.target_directory}"

    load_ok = false
    Dir.mktmpdir do |tmp_dir|
      # clone repository into tmp dir
      output=`git clone #{Gitnesse.repository_url} #{tmp_dir} 2>&1`; repo_cloned=$?.success?

      if repo_cloned
        FileUtils.mkdir(Gitnesse.target_directory) unless File.exists?(Gitnesse.target_directory)
        feature_files = File.join(tmp_dir, "**", "*.feature")
        FileUtils.cp_r(Dir.glob(feature_files), Gitnesse.target_directory)
        load_ok = true
      else
        puts output
      end
    end

    if load_ok
      puts "Now going to run cucumber..."
      exec("cucumber #{Gitnesse.target_directory}/*.feature")
    end
  end
  module_function :perform
end