module Gitnesse
  class Cli
    module WikiHelpers
      # Public: Clones or updates local copy of remote git-based wiki. Also prints
      # message indicating which operation is taking place
      #
      # Returns instance of Gitnesse::Wiki referring to new/updated local wiki
      def clone_wiki
        opts = {}
        @dir = Gitnesse::DirManager.project_dir

        if Gitnesse::DirManager.project_dir_present?
          opts[:present] = true
        else
          opts[:present] = false
          Gitnesse::DirManager.make_project_dir
        end

        @wiki = Gitnesse::Wiki.new @config.repository_url, @dir, opts
      end

      # Public: Removes existing features from local copy of remote wiki.
      #
      # Returns nothing.
      def remove_existing_features
        @wiki.remove_features
      end

      # Public: Commits wiki changes, and pushes changes to remote wiki.
      #
      # Returns nothing.
      def commit_and_push_changes
        puts "  Commiting changes."
        @wiki.commit

        puts "  Pushing changes to remote wiki."
        @wiki.push
      end

      # Public: Extracts wiki pages that contain cucumber features.
      #
      # Returns an array of wiki pages containing features
      def extract_features_from_wiki
        unless @wiki.pages.any?
          abort "  Wiki contains no features."
        end

        puts "  Extracting wiki pages containing features."

        @feature_pages = @wiki.pages.select do |page|
          Gitnesse::FeatureExtractor.contains_features? page.read
        end
      end
    end
  end
end
