require "gollum"

module WikiTestMethods

  # Creates a new Gollum wiki for testing
  #
  # Returns a gollum wiki
  def create_wiki(dir = Dir.mktmpdir)
    Gollum::Wiki.new(dir)
  end
end
