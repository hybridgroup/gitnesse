require "gitnesse/version"

module Gitnesse
  def self.wiki_url
    @@wiki_url
  end

  def self.wiki_url=(wiki_url)
    @@wiki_url = wiki_url
  end

  def self.setup
    yield self
  end
end
