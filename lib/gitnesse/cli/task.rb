Dir["#{File.dirname(__FILE__)}/helpers/*.rb"].each { |f| require f }

module Gitnesse
  class Cli
    class Task
      include Gitnesse::Cli::ConfigHelpers
      include Gitnesse::Cli::FeatureHelpers
      include Gitnesse::Cli::WikiHelpers

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
        @config = Gitnesse::Config.instance
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
