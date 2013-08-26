module Gitnesse
  class Cli
    class Task
      attr_accessor :out

      class << self
        attr_accessor :name

        def desc(string = nil)
          string ? @desc = string : @desc
        end

        def help
          block_given? ? @help = yield : @help
        end
      end

      def initialize(out)
        @out = out
      end

      def perform(*); end
      def description; end
      def help; end

      private
      def puts(*args)
        out.puts *args
      end

      def print(*args)
        out.print *args
      end

      def abort(*args)
        out.puts *args
        exit 1
      end

      # Loads and checks Gitnesse configuration/dependencies
      #
      # Returns an instance of Gitnesse::Config
      def load_and_check_config
        Gitnesse::ConfigLoader.find_and_load
        Gitnesse::DependencyChecker.new.check

        @config = Gitnesse::Config.instance
      end

      # Clones or updates local copy of remote git-based wiki. Also prints
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

    end

    def tasks
      @tasks ||= Hash[self.class.tasks.map { |name, t| [name, t.new(out)] }]
    end

    class << self
      def task(*names, &block)
        task = Class.new(Task, &block)
        names.map!(&:to_s)
        task.name = names.first
        names.each { |name| tasks[name] = task }
      end

      def tasks
        @tasks ||= {}
      end
    end
  end
end

Dir[File.dirname(__FILE__) + "/task/*.rb"].each { |f| require(f) }
