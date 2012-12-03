require 'bundler/setup'
require 'gollum'
require 'fileutils'
require 'tmpdir'
require 'gitnesse/configuration'
require 'gitnesse/git_config'
require 'gitnesse/dependencies'
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
          page_name =  page.name.gsub('.feature', '')
          page_features = Wiki.extract_features(page)
          write_feature_file(page_name, page_features) unless page_features.empty?
        end
      end
    end
    puts "  Done pulling features."
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

  # we are going to support only one feature per page
  def gather_features(page_features)
    return "" if page_features.nil? or page_features.empty?

    features = ''
    feature_name, feature_content = page_features.shift
    puts "  # Pulling Feature: #{feature_name}"
    features = features + feature_content

    page_features.each do |_feature_name, _feature_content|
      puts "  # WARNING! Discarded Feature: #{_feature_name}"
      puts _feature_content
    end

   features
  end

  def write_feature_file(page_name, page_features)
    File.open("#{Gitnesse.configuration.target_directory}/#{page_name}.feature","w") {|f| f.write(gather_features(page_features)) }
  end

  def load_config
    load(ENV['GITNESSE_CONFIG']) and return if ENV['GITNESSE_CONFIG']

    possible_config_files = Dir.glob(File.join("**", "gitnesse.rb"))

    files_with_config = possible_config_files.select do |file_name|
      if FileUtils.compare_file(__FILE__, file_name)
        false
      elsif File.fnmatch("vendor/**/*.rb", file_name)
        false
      else
        file_content = File.read(file_name)
        file_content.match("Gitnesse.configure")
      end
    end

    case files_with_config.length
      when 0
        raise "Can't find a gitnesse.rb file with Gitnesse configuration."
      when 1
        load(File.absolute_path(files_with_config.first))
      else
        raise "Several config files found: #{files_with_config.join(", ")}"
    end
  end
end
