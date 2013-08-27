require 'spec_helper'
require 'gitnesse/cli'

module Gitnesse
  describe Cli, type: :cli do
    let(:help) do
      <<-EOS
USAGE: gitnesse push

Pushes local features to remote git-based wiki

Pushes the local features files to the remote git-based wiki, creating/updating
wiki pages as necessary.

Examples:
  gitnesse push  # will push local features to remote wiki
      EOS
    end

    it "has help info" do
      expect(gitnesse("help push")).to eq help
    end
  end
end
