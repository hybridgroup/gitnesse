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
  end

  private
  def extract_features_from_wiki
    puts "  Extracting wiki pages containing features."

    feature_pages = @wiki.pages.select do |page|
      Gitnesse::FeatureExtractor.contains_features? page.content
    end

    @features_and_files = feature_pages.each_with_object([]) do |page, arr|
      arr << {
        name: page.name,
        features: Gitnesse::FeatureExtractor.extract!(page.content)
      }
    end
  end

  def create_or_update_local_features
    puts "  Creating and updating local features."

    @features_and_files.each do |feature|
      filename = "#{@config.features_dir}/#{feature[:name]}.feature"

      if File.exists?(filename)
        puts "    - Updating #{filename}"
      else
        puts "    - Creating #{filename}"
      end

      File.open filename, 'w' do |file|
        feature[:features].each do |f|
          file.write f
        end
      end
    end
  end
end
