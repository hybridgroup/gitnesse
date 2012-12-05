require 'bundler/setup'
require 'gollum'
require 'fileutils'
require 'tmpdir'
require 'gitnesse/configuration'
require 'gitnesse/git_config'
require 'gitnesse/dependencies'
require 'gitnesse/features'
require 'gitnesse/hooks'
require 'gitnesse/wiki'
require 'gitnesse/railtie' if defined?(Rails)

# core module
module Gitnesse
  class << self
    attr_accessor :configuration
    attr_accessor :commit_info
  end

  self.configuration ||= Configuration.new

  extend self

  def self.configure
    yield(configuration)
  end

  # -- all methods after this are module functions --
  module_function

  def run
    if pull
      Hooks.create
      puts "Now going to run cucumber..."
      exec("cucumber #{Gitnesse.configuration.target_directory}/*.feature")
    end
  end

  def push_results
    if push
      Hooks.create
      puts "Now going to run cucumber..."
      exec("cucumber #{Gitnesse.configuration.target_directory}/*.feature")
    end
  end

  # pull features from git wiki, and sync up with features dir
  def pull
    Dependencies.check

    puts "Pulling features into #{Gitnesse.configuration.target_directory} from #{Gitnesse.configuration.repository_url}..."
    Dir.mktmpdir do |tmp_dir|
      if clone_feature_repo(tmp_dir)
        FileUtils.mkdir(Gitnesse.configuration.target_directory) unless File.exists?(Gitnesse.configuration.target_directory)

        wiki_pages = Wiki.new(tmp_dir).pages
        wiki_pages.each do |page|
          name =  page.name.gsub('.feature', '')
          filename = "#{Gitnesse.configuration.target_directory}/#{name}.feature"
          features = Wiki.extract_features(page)
          Features.write_file(filename, features) unless features.empty?
        end
      end
    end
    puts "  Done pulling features."
    true
  end

  # push features back up to git wiki from features directory
  def push
    Dependencies.check
    generate_commit_info

    puts "Pushing features from #{Gitnesse.configuration.target_directory} to #{Gitnesse.configuration.repository_url}..."
    Dir.mktmpdir do |tmp_dir|
      if clone_feature_repo(tmp_dir)
        feature_files = Dir.glob("#{Gitnesse.configuration.target_directory}/*.feature")
        Wiki.new(tmp_dir).load_feature_files(feature_files)

        # push the changes to the remote git
        Dir.chdir(tmp_dir) do
          puts `git push origin master`
        end
      end
    end
    puts "  Done pushing features."
    true
  end

  def clone_feature_repo(dir)
    output = `git clone #{Gitnesse.configuration.repository_url} #{dir} 2>&1`
    puts output
    $?.success?
  end

  def generate_commit_info
    self.commit_info ||= begin
      user_name = GitConfig.read("user.name")
      email = GitConfig.read("user.email")
      { :name => user_name, :email => email, :message => "Update features with Gitnesse" }
    end
  end
end
