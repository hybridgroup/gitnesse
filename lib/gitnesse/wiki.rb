Dir[File.dirname(__FILE__) + "/wiki/*.rb"].each { |f| require(f) }

require 'grit'

module Gitnesse
  class Wiki
    attr_reader :repo, :pages

    # Public: Clones a wiki into the provided dir
    #
    # repository_url - cloneable URL for wiki repository
    # dir - directory to clone git wiki into
    #
    # Returns a Gitnesse::Wiki object
    def initialize(repository_url, dir)
      `git clone #{repository_url} #{dir} &> /dev/null`
      @repo = Grit::Repo.new dir
      @pages = @repo.status.map do |s|
        Gitnesse::Wiki::Page.new("#{dir}/#{s.path}") if s.path =~ /\.md$/
      end

      @pages
    end
  end
end
