Gitnesse::Cli.task :info do
  desc "Prints current Gitnesse configuration"

  def perform
    config = Gitnesse::Config.instance.to_h
    size = config.keys.map(&:length).max

    puts "Current Gitnesse Configuration:"

    config.each do |key, value|
      puts "  #{key.to_s.rjust(size)} - #{value || "[not set]"}"
    end
  end

  help do
    <<-EOS
USAGE: gitnesse info

#{desc}

Prints the current Gitnesse configuration settings, including settings loaded
from gitnesse.rb configuration files.

Examples:
  gitnesse list  # will print current configuration
    EOS
  end
end
