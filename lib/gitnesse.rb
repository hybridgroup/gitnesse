require 'bundler/setup'
require 'gollum'
require 'fileutils'
require 'tmpdir'
require 'gitnesse/railtie' if defined?(Rails::Railtie)

# core module
module Gitnesse

  # Public: Return String with url of the git wiki repo containing features.
  #
  def self.repository_url
    @@repository_url
  end

  # Public: Set url of the git-based wiki repo containing features.
  #
  # repository_url - A String containing your repo's url.
  #
  # Example:
  #
  #   Gitnesse.config do |config|
  #     config.repository_url = "git@github.com:luishurtado/gitnesse-wiki.wiki"
  #   end
  #
  def self.repository_url=(repository_url)
    @@repository_url = repository_url
  end

  # Public: Return String with branch of the git-based wiki repo containing features.
  #
  def self.branch
    @@branch ||= "master"
  end

  # Public: Set branch of the git-based wiki repo containing features.
  #
  # branch - A String containing which branch of your repo to use.
  #
  # Example:
  #
  #   Gitnesse.config do |config|
  #     config.branch = "master"
  #   end
  #
  def self.branch=(branch)
    @@branch = branch
  end

  # Public: Return String with which directory being used to sync with git-wiki stored feature stories.
  #
  def self.target_directory
    @@target_directory ||= File.join(Dir.pwd, 'features')
  end

  # Public: Set local directory used to sync with git-wiki stored feature stories.
  #
  # target_directory - A String containing which directory to use.
  #
  # Example:
  #
  #   Gitnesse.config do |config|
  #     config.target_directory = "features"
  #   end
  #
  def self.target_directory=(target_directory)
    @@target_directory = target_directory
  end

  def self.config
    yield self
  end

  def run
    if pull
      puts "Now going to run cucumber..."
      exec("cucumber #{Gitnesse.target_directory}/*.feature")
    end
  end
  module_function :run

  # pull features from git wiki, and sync up with features dir
  def pull
    ensure_git_available
    ensure_cucumber_available
    ensure_repository

    puts "Pulling features into: #{Gitnesse.target_directory} from #{Gitnesse.repository_url}..."
    Dir.mktmpdir do |tmp_dir|
      if clone_feature_repo(tmp_dir)
        FileUtils.mkdir(Gitnesse.target_directory) unless File.exists?(Gitnesse.target_directory)

        wiki_pages = Gollum::Wiki.new(tmp_dir).pages
        wiki_pages.each do |wiki_page|
          page_features = extract_features(wiki_page.raw_data)
          write_feature_file(wiki_page.name, page_features) unless page_features.empty?
        end
      end
    end
    puts "DONE."
  end
  module_function :pull

  # TODO: push features back up to git wiki from features directory
  def push
    ensure_git_and_cucumber_available
    ensure_repository

    puts "Not implemented yet... pull request for push please!"
  end
  module_function :push

  # look thru wiki page for features
  def extract_features(data)
    features = {}

    if match_result = data.match(/\u0060{3}(.+)\u0060{3}/m)
      captures = match_result.captures

      # create hash with feature name as key and feature text as value
      captures.each do |capture|
        feature_definition_at = capture.index('Feature:')
        feature_text = capture[feature_definition_at,capture.size-1]
        feature_lines = feature_text.split("\n")
        feature_definition = feature_lines.grep(/^Feature:/).first

        if feature_definition
          feature_name = feature_definition.split(":").last.strip.gsub(" ","-").downcase
          features[feature_name] = feature_text
        end
      end
    end

    features
  end
  module_function :extract_features

  def clone_feature_repo(dir)
    output = `git clone #{Gitnesse.repository_url} #{dir} 2>&1`
    puts output
    $?.success?
  end
  module_function :clone_feature_repo

  def gather_features(page_features)
    features = ''
    page_features.each do |feature_name, feature_content|
      puts "============================== #{feature_name} =============================="
      puts feature_content
      features = features + feature_content
    end
    features
  end
  module_function :gather_features

  def write_feature_file(page_name, page_features)
    File.open("#{Gitnesse.target_directory}/#{page_name}.feature","w") {|f| f.write(gather_features(page_features)) }
  end
  module_function :write_feature_file

  def ensure_git_available
    raise "git not found or not working." unless Kernel.system("git --version")
  end
  module_function :ensure_git_available

  def ensure_cucumber_available
    raise "cucumber not found or not working." unless Kernel.system("cucumber --version")
  end
  module_function :ensure_cucumber_available

  def ensure_repository
    raise "You must select a repository_url to run Gitnesse." if Gitnesse.repository_url.nil?
  end
  module_function :ensure_repository
end
