Dir[File.dirname(__FILE__) + "/wiki/*.rb"].each { |f| require(f) }

require 'git'

module Gitnesse
  class Wiki
    attr_reader :repo, :pages, :dir

    # Public: Clones/updates a wiki in the provided dir
    #
    # url - cloneable URL for wiki repository
    # dir - directory to clone git wiki into
    # opts - hash of options:
    #   clone - whether or not to clone/update local copy of remote wiki
    #
    # Returns a Gitnesse::Wiki object
    def initialize(url, dir, opts={clone: true})
      @url = url
      @dir = dir
      @opts = opts
      @config = Gitnesse::Config.instance

      clone_or_update_repo unless !opts[:clone]

      @repo ||= Git.init(dir)

      @pages = @repo.status.each_with_object([]) do |s, a|
        if s.path =~ /\.feature\.md$/
          a << Gitnesse::Wiki::Page.new("#{dir}/#{s.path}")
        end
      end

      @pages
    end

    # Public: Removes pages previously placed by Gitnesse. This includes the
    # feature listing pages.
    #
    # Returns nothing.
    def remove_features
      @repo.status.each do |file|
        if file.path =~ /^features(\.md|\ >)/
          begin
            @repo.remove(file.path)
          rescue Git::GitExecuteError => e
            # Git spat something on git rm [file]. Likely the file doesn't
            # exist, or was previously removed and hasn't been committed yet.
            # It's likely fine. If not, we'll abort and show the end user the
            # error Git sent to us.
            unless e.message =~ /did not match any files/
              puts "  A Git error occured. The message it passed to us was:"
              abort e.message
            end
          end
        end
      end
    end

    # Public: Commits staged wiki changes
    #
    # Returns nothing
    def commit
      begin
        @repo.commit("Update features with Gitnesse")
      rescue Git::GitExecuteError => e
        unless e.message =~ /nothing to commit/
          puts "  A Git error occured. The message it passed to us was:"
          abort e.message
        end
      end
    end

    # Public: Pushes new commits to remote wiki
    #
    # Returns nothing
    def push
      @repo.push
    end

    # Public: Adds or updates wiki page
    #
    # filename - filename for wiki page
    # content - content for page
    #
    # Returns a Wiki::Page
    def add_page(filename, content)
      full_filename = "#{@dir}/#{filename}"

      if @pages.detect { |f| f.wiki_path == full_filename }
        page = @pages.find { |f| f.wiki_path == full_filename }
      else
        page = Gitnesse::Wiki::Page.new(full_filename)
        @pages << page
      end

      page.write(content)
      @repo.add(filename)
      page
    end

    private
    # Private: Clones or Updates the local copy of the remote wiki
    #
    # Returns nothing
    def clone_or_update_repo
      if File.directory?(@dir + "/.git")
        puts "  Updating local copy of remote wiki."
        @repo = Git.open(@dir)
        @repo.pull('origin', @config.branch)
      else
        puts "  Creating local copy of remote wiki."
        Dir.mkdir @dir unless File.directory?(@dir)
        @repo = Git.clone @url, @dir
      end

      @repo.checkout(@config.branch)
    end
  end
end
