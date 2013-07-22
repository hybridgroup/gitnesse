require 'fileutils'
require 'tempfile'
require 'tmpdir'

module CliSpecs
  def gitnesse(args)
    out = StringIO.new
    Gitnesse::Cli.new(out).parse(args.split(/\s+/))

    out.rewind
    out.read
  rescue SystemExit
    out.rewind
    out.read
  end
end

RSpec.configure do |c|
  c.include CliSpecs, type: :cli
end
