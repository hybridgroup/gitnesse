Gitnesse::Cli.task :run do
  desc "Pulls changes from remote git-based wiki, and runs Cucumber."

  help do
    <<-EOS
USAGE: gitnesse run

#{desc}

Pulls changed features from remote git-based wiki, runs Cucumber, and pushes
annotated results to the remote git-based wiki if the "annotate_results" setting
is enabled.

Examples:
  gitnesse run  # will pull changes, run cucumber, and annotate results
    EOS
  end

  def perform
    load_and_check_config
    clone_wiki
    extract_features_from_wiki
    create_or_update_local_features

    puts "  Local features updated."

    remove_existing_results_from_wiki

    create_hooks
    run_features
    remove_hooks

    push_annotated_results_to_wiki

    puts "  Done."
  end

  # Public: Removes existing Gitnesse results from all wiki pages
  #
  # Returns nothing
  def remove_existing_results_from_wiki
    @wiki.pages.each(&:remove_results) if @config.annotate_results
  end

  # Public: Installs Gitnesse hooks for Cucumber
  #
  # Returns nothing
  def create_hooks
    if @config.annotate_results
      puts "  Installing Gitnesse Cucumber hooks."
      Gitnesse::Hooks.create!
    end
  end

  # Public: Removes installed Gitnesse Cucumber hooks
  #
  # Returns nothing
  def remove_hooks
    if @config.annotate_results
      puts "  Removing Gitnesse Cucumber hooks."
      Gitnesse::Hooks.destroy!
    end
  end

  # Public: Runs Cucumber features
  #
  # Returns nothing
  def run_features
    puts "  Running cucumber."
    puts '  -------------------', ''
    if defined?(Bundler)
      Bundler.with_clean_env { system "cucumber #{@config.features_dir}" }
    else
      system "cucumber #{@config.features_dir}"
    end
    puts '  -------------------', ''
  end

  # Public: Pushes features with annotations to remote wiki
  #
  # Returns nothing
  def push_annotated_results_to_wiki
    if @config.annotate_results
      puts "  Pushing annotated results to remote wiki."
      @wiki.commit
      @wiki.push
    end
  end
end
