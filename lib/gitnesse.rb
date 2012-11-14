require 'bundler/setup'
require 'gollum'
require 'fileutils'
require 'tmpdir'
require 'gitnesse/railtie' if defined?(Rails::Railtie)

# core module
module Gitnesse

  extend self

  # Public: Set url of the git-based wiki repo containing features.
  #
  # repository_url - A String containing your repo's url.
  #
  # Example:
  #
  #   Gitnesse.config do
  #     repository_url  "git@github.com:luishurtado/gitnesse-wiki.wiki"
  #   end
  #
  def self.repository_url(repository_url = false)
    if repository_url == false
      @@repository_url
    else
      @@repository_url = repository_url
    end
  end

  # Public: Set branch of the git-based wiki repo containing features.
  #
  # branch - A String containing which branch of your repo to use.
  #
  # Example:
  #
  #   Gitnesse.config do
  #     branch "master"
  #   end
  #
  def self.branch(branch = false)
    if branch == false
      @@branch ||= "master"
    else
      @@branch = branch
    end
  end

  # Public: Set local directory used to sync with git-wiki stored feature stories.
  #
  # target_directory - A String containing which directory to use.
  #
  # Example:
  #
  #   Gitnesse.config do
  #     target_directory "features"
  #   end
  #
  def self.target_directory(target_directory = false)
    if target_directory == false
      @@target_directory ||= File.join(Dir.pwd, 'features')
    else
      @@target_directory = target_directory
    end
  end

  def self.config(&block)
    instance_eval &block
  end

  # -- all methods after this are module functions --
  module_function

  def run
    if pull
      puts "Now going to run cucumber..."
      exec("cucumber #{Gitnesse.target_directory}/*.feature")
    end
  end

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

  # push features back up to git wiki from features directory
  def push
    ensure_git_available
    ensure_cucumber_available
    ensure_repository
    commit_info

    Dir.mktmpdir do |tmp_dir|
      if clone_feature_repo(tmp_dir)
        load_feature_files_into_wiki(tmp_dir)

        # push the changes to the remote git
        Dir.chdir(tmp_dir) do
          puts `git push origin master`
        end
      end
    end

  end

  def load_feature_files_into_wiki(tmp_dir)
    wiki = Gollum::Wiki.new(tmp_dir)
    feature_files = Dir.glob("#{Gitnesse.target_directory}/*.feature")

    feature_files.each do |feature_file|
      feature_name    = File.basename(feature_file, ".feature")
      feature_content = File.read(feature_file)
      wiki_page       = wiki.page(feature_name)

      if wiki_page
        update_wiki_page(wiki, wiki_page, feature_name, feature_content)
      else
        create_wiki_page(wiki, feature_name, feature_content)
      end
    end
  end

  def create_wiki_page(wiki, page_name, feature_content)
    new_page_content = build_page_content(feature_content)

    wiki.write_page(page_name, :markdown, new_page_content, commit_info)
    puts "==== Created page: #{page_name} ==="
  end

  def update_wiki_page(wiki, wiki_page, page_name, feature_content)
    wiki_page_content = wiki_page.raw_data
    new_page_content = build_page_content(feature_content, wiki_page_content)

    if new_page_content == wiki_page_content
      puts "=== Page #{page_name} didn't change ==="
    else
      wiki.update_page(wiki_page, page_name, :markdown, new_page_content, commit_info)
      puts "==== Updated page: #{page_name} ==="
    end
  end

  def build_page_content(feature_content, wiki_page_content = nil)
    return "```gherkin\n#{feature_content}\n```" if wiki_page_content.nil? || wiki_page_content.empty?
    features = extract_features(wiki_page_content)

    # replace the first feature found in the wiki page
    _, old_feature_content = features.shift
    wiki_page_content.sub(old_feature_content, feature_content)
  end

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

  def clone_feature_repo(dir)
    output = `git clone #{Gitnesse.repository_url} #{dir} 2>&1`
    puts output
    $?.success?
  end

  def commit_info
    @commit_info ||= begin
      user_name = read_git_config("user.name")
      email = read_git_config("user.email")
      raise "Can't read git's user.name config" if user_name.nil? || user_name.empty?
      raise "Can't read git's user.email config" if email.nil? || email.empty?

      {:name => user_name, :email => email, :message => "Update features with Gitnesse"}
    end
  end

  def commit_info=(commit_info)
    @commit_info = commit_info
  end

  def read_git_config(config_name)
    config_value = ""
    config_value = `git config --get #{config_name}`
    config_value = `git config --get --global #{config_name}` unless $?.success?
    config_value.strip
  end

  # we are going to support only one feature per page
  def gather_features(page_features)
    return "" if page_features.nil? or page_features.empty?

    features = ''
    feature_name, feature_content = page_features.shift
    puts "============================== Pulling Feature: #{feature_name} =============================="
    features = features + feature_content

    page_features.each do |_feature_name, _feature_content|
      puts "============================== WARNING! Discarded Feature: #{_feature_name} =============================="
      puts _feature_content
    end

    features
  end

  def write_feature_file(page_name, page_features)
    File.open("#{Gitnesse.target_directory}/#{page_name}.feature","w") {|f| f.write(gather_features(page_features)) }
  end

  def ensure_git_available
    raise "git not found or not working." unless Kernel.system("git --version")
  end

  def ensure_cucumber_available
    raise "cucumber not found or not working." unless Kernel.system("cucumber --version")
  end

  def ensure_repository
    raise "You must select a repository_url to run Gitnesse." if Gitnesse.repository_url.nil?
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
        file_content.match("Gitnesse.config")
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

  def config_to_hash
    { "repository_url" => Gitnesse.repository_url,
      "branch" => Gitnesse.branch,
      "target_directory" => Gitnesse.target_directory }
  end

  def method_missing(sym, *args, &block)
    raise "Invalid variable name for Gitnesse configuration.
           Allowed variables are repository_url, branch, and target_directory."
  end
end
