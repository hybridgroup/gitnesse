Gitnesse::Cli.task :push do
  desc "Pushes local features to remote git-based wiki"

  help do
    <<-EOS
USAGE: gitnesse push

#{desc}

Pushes the local features files to the remote git-based wiki, creating/updating
wiki pages as necessary.

Examples:
  gitnesse push  # will push local features to remote wiki
    EOS
  end

  def perform
    load_and_check_config
    clone_wiki
    remove_existing_features
    collect_features
    add_index_page
    add_feature_index_pages_to_wiki
    add_features_to_wiki
    commit_and_push_changes

    puts "  Done."
  end

  private
  def collect_features
    puts "  Collecting local features."
    Dir.chdir @config.features_dir do
      @features = Dir.glob("**/*.feature").each_with_object([]) do |f, a|
        a << Gitnesse::Feature.new(f)
      end
    end

    unless @features.any?
      abort "  No local features found."
    end
  end

  def add_feature_index_pages_to_wiki
    nested = @features.group_by(&:index_page)
    nested.reject! { |k,v| k == 'features.md' }

    if nested.any?
      puts "  Creating index pages:"
    end

    nested.each do |filename, features|
      content = features.each_with_object("") do |f, s|
        s << "- #{f.relative_link}\n"
      end

      puts "    - #{filename}"

      @wiki.add_page(filename, content)
    end
  end

  def add_features_to_wiki
    puts "  Creating/updating wiki features:"
    @features.each do |feature|
      puts "    - #{feature.wiki_filename}"

      filename = feature.wiki_filename
      content = Gitnesse::FeatureTransform.convert(feature.read)
      @wiki.add_page(filename, content)
    end
  end

  def add_index_page
    filename = "features.md"
    content = "# Features\n\n"

    puts "  Creating index page: #{filename}"

    nested = @features.group_by(&:index_page)

    if nested.key?("features.md") && nested["features.md"].any?
      features = nested.delete("features.md")

      features.each do |f|
        content << "- #{f.relative_link}\n"
      end
    end

    nested.each do |folder, features|
      content << "- **[[#{folder.gsub('.md', '')}|#{folder}]]**\n"

      features.each do |f|
        content << "    - #{f.relative_link}\n"
      end
    end

    @wiki.add_page(filename, content)
  end
end
