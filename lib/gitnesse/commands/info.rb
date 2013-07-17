module Gitnesse
  module Commands
    class Info
      def self.run
        config = Gitnesse::Config.instance

        puts "Current Gitnesse Configuration:"
        config.to_h.each { |k,v| puts "  #{k}: #{v}" }
      end
    end
  end
end
