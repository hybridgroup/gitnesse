Gitnesse::Cli.task :run do
  desc "Pulls changes from remote git-based wiki, and runs Cucumber."

  help do
    <<-EOS
USAGE: gitnesse run

#{desc}

Pulls changed features from remote git-based wiki, runs Cucumber, and pushes
annotated results to the remote git-based wiki if the "annotate_results" setting
is enabled.

Unlike other commands, all arguments passed to gitnesse run will be passed
through to Cucumber if you only want to run specific cukes.

Examples:
  gitnesse run  # will pull changes, run cucumber, and annotate results
  gitnesse run ./features/addition.feature
    EOS
  end

  def perform(*args)
    load_and_check_config
    clone_wiki
    extract_features_from_wiki
    create_or_update_local_features

    puts "  Local features updated."

    remove_existing_results_from_wiki

    create_hooks
    run_features(args)
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
  # args - optional array of arguments to be passed to Cucumber
  #
  # Returns nothing
  def run_features(args = [])
    puts "  Running cucumber.", '  -------------------', ''
    args = (args.empty? ? @config.features_dir : args.join(' '))

    if defined?(Bundler)
      Bundler.with_clean_env { system "bundle exec cucumber #{args}" }
    else
      system "bundle exec cucumber #{args}"
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
