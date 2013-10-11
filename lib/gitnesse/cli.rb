require 'gitnesse'

require 'optparse'
require 'optparse/version'

require 'gitnesse/cli/task'

module Gitnesse
  class Cli
    attr_accessor :out, :parser

    def initialize(out = STDOUT)
      @out = out
      setup_parser
    end

    def parse(args = ARGV)
      # gitnesse run will pass all arguments onto cucumber
      parser.parse! args unless ARGV.first == "run"

      arg = args.shift.to_s

      if task = tasks[arg]
        task.perform(*args)
      else
        abort "No such task."
      end
    end

    private
    def setup_parser
      @parser = OptionParser.new do |o|
        o.on_tail '-v', '--version' do
          puts parser.ver
          exit
        end
      end

      parser.program_name = 'gitnesse'
      parser.version = Gitnesse::VERSION
    end

    def print(*args)
      out.print *args
    end

    def puts(*args)
      out.puts *args
    end

    def abort(*args)
      puts *args
      exit 1
    end
  end
end
