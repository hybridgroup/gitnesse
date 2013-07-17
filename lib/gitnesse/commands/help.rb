module Gitnesse
  module Commands
    class Help
      def self.run
        puts <<-EOS
Gitnesse commands:
  run - pull remote features from git wiki to local features, then run Cucumber
  push - push local features to remote git wiki
  pull - pull remote features from git wiki to local
  info - print current Gitnesse configuration
        EOS
      end
    end
  end
end
