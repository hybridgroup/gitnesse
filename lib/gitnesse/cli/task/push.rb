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
    collect_features
    add_features_to_wiki
    commit_and_push_changes
  end

  private
  def collect_features
    puts "  Collecting local features."
    Dir.chdir @config.features_dir do
      @features = Dir.glob("**/*.feature")
    end
  end

  def add_features_to_wiki
    unless @features.any?
      abort "  No local features found."
    end

    @features.each do |feature|
      @wiki.add_feature_page feature
    end
  end

  def commit_and_push_changes
    Dir.chdir @wiki.dir do
      puts "  Committing updated wiki features."
      `git add . &> /dev/null`
      `git commit -m "Update features with Gitnesse" &> /dev/null`
      puts "  Pushing updated features to remote wiki."
      `git push origin #{@config.branch} &> /dev/null`
    end

    puts "  Done."
  end
end
