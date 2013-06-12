module Gitnesse
  class CommitInfoGenerator
    def self.generate
      {
        name: GitConfigReader.read('user.name'),
        email: GitConfigReader.read('user.email'),
        message: "Updated features with Gitnesse."
      }
    end
  end
end
