Gitnesse::Cli.task :pull do
  desc "Pulls features from remote git-based wiki"

  help do
    <<-EOS
USAGE: gitnesse pull

#{desc}

Pulls the remote wiki, finds the feature files it contains, and updates the
relevant local features, creating new ones if necessary.

Examples:
  gitnesse pull  # will pull features from remote wiki
    EOS
  end

  def perform
    load_and_check_config
    clone_wiki
    extract_features_from_wiki
    create_or_update_local_features

    puts "  Done."
  end

  private
  def extract_features_from_wiki
    unless @wiki.pages.any?
      abort "  Wiki contains no features."
    end

    puts "  Extracting wiki pages containing features."

    @feature_pages = @wiki.pages.select do |page|
      Gitnesse::FeatureExtractor.contains_features? page.read
    end
  end

  def create_or_update_local_features
    puts "  Creating and updating local features."

    @feature_pages.each do |page|
      if File.exists?(page.path)
        puts "    - Updating #{page.path}"
      else
        puts "    - Creating #{page.path}"
        FileUtils.mkdir_p page.relative_path
      end

      features = Gitnesse::FeatureExtractor.extract!(page.read)

      File.open page.path, 'w' do |file|
        features.each do |feature|
          file.write(feature)
        end
      end
    end
  end
end
