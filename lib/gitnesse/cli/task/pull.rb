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
end
