Dir[File.dirname(__FILE__) + "/wiki/*.rb"].each { |f| require(f) }

require 'grit'

module Gitnesse
  class Wiki
    attr_reader :repo, :pages, :dir

    # Public: Clones/updates a wiki in the provided dir
    #
    # repository_url - cloneable URL for wiki repository
    # dir - directory to clone git wiki into
    # opts - hash of options:
    #   present - whether or not wiki has been previously cloned into dir
    #
    # Returns a Gitnesse::Wiki object
    def initialize(repository_url, dir, opts={})
      @dir = dir

      clone_or_update_repo repository_url, dir, !!opts[:present]

      @repo = Grit::Repo.new dir

      @pages = @repo.status.each_with_object([]) do |s, a|
        if s.path =~ /\.feature\.md$/
          a << Gitnesse::Wiki::Page.new("#{dir}/#{s.path}")
        end
      end

      @pages
    end

    # Public: Adds a new feature page to the Wiki
    #
    # feature_path - relative path from Gitnesse::Config.instance.features_path
    # to feature file
    #
    # Returns new Gitnesse::Wiki::Page
    def add_feature_page(feature_path)
      config = Gitnesse::Config.instance
      feature = File.read("#{config.features_dir}/#{feature_path}")

      name = "features/#{feature_path}.md".gsub('/', ' > ')
      filename = "#{@dir}/#{name}"
      content = Gitnesse::FeatureTransform.convert(feature)

      if File.exists?(filename)
        puts "    Updating page: '#{name}'"
      else
        puts "    Creating page: '#{name}'"
      end

      File.open(filename, 'w') do |f|
        f.write content
      end
    end

    private
    # Private: Clones or Updates the local copy of the remote wiki
    #
    # url - clonable URL for remote wiki repo
    # dir - directory to clone git wiki into
    # present - whether or not wiki is already present
    #
    # Returns nothing
    def clone_or_update_repo(url, dir, present)
      branch = Gitnesse::Config.instance.branch

      if present
        puts "  Updating local copy of remote wiki."
        Dir.chdir(dir) { `git pull origin #{branch} &> /dev/null` }
      else
        puts "  Creating local copy of remote wiki."
        `git clone #{url} #{dir} &> /dev/null`
        `git checkout #{branch} &> /dev/null`
      end
    end
  end
end
