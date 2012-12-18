require 'bundler/setup'
require 'gollum'
require 'fileutils'
require 'pathname'
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
      puts "\n  Now going to run Cucumber."
      exec("cucumber #{Gitnesse.configuration.target_directory}/*.feature")
    end
  end

  def push_results
    if push
      Hooks.create
      puts "\n  Now going to run Cucumber."
      exec("cucumber #{Gitnesse.configuration.target_directory}/*.feature")
    end
  end

  # pull features from git wiki, and sync up with features dir
  def pull
    Dependencies.check

    relative_path = Pathname.new(Gitnesse.configuration.target_directory).relative_path_from(Pathname.new(Dir.pwd))

    puts "  Pulling features into ./#{relative_path} from #{Gitnesse.configuration.repository_url}."
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
    puts "  \e[32mDone pulling features.\e[0m"
    true
  end

  # push features back up to git wiki from features directory
  def push
    Dependencies.check
    generate_commit_info

    relative_path = Pathname.new(Gitnesse.configuration.target_directory).relative_path_from(Pathname.new(Dir.pwd))

    puts "  Pushing features from ./#{relative_path} to #{Gitnesse.configuration.repository_url}."
    Dir.mktmpdir do |tmp_dir|
      if clone_feature_repo(tmp_dir)
        feature_files = Dir.glob("#{Gitnesse.configuration.target_directory}/*.feature")
        Wiki.new(tmp_dir).load_feature_files(feature_files)

        # push the changes to the remote git
        Dir.chdir(tmp_dir) do
          `git push origin master &> /dev/null`
        end
      end
    end
    puts "  \e[32mDone pushing features.\e[0m"
    true
  end

  def clone_feature_repo(dir)
    output = `git clone #{Gitnesse.configuration.repository_url} #{dir} &> /dev/null`
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
