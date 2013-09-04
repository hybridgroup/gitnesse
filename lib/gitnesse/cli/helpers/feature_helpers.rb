module Gitnesse
  class Cli
    module FeatureHelpers
      # Public: Creates or updates local cucumber features
      #
      # Returns nothing.
      def create_or_update_local_features
        puts "  Creating and updating local features."

        @feature_pages.each do |page|
          if File.exists?(page.path)
            puts "    - Updating #{page.path}"
          else
            puts "    - Creating #{page.path}"
            FileUtils.mkdir_p page.relative_path
          end

          feature = Gitnesse::Feature.new(page.path)
          feature.write(Gitnesse::FeatureExtractor.extract!(page.read))
        end
      end
    end
  end
end
