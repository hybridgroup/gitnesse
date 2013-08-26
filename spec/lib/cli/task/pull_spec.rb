require 'spec_helper'
require 'gitnesse/cli'

module Gitnesse
  describe Cli, type: :cli do
    let(:help) do
      <<-EOS
USAGE: gitnesse pull

Pulls features from remote git-based wiki

Pulls the remote wiki, finds the feature files it contains, and updates the
relevant local features, creating new ones if necessary.

Examples:
  gitnesse pull  # will pull features from remote wiki
      EOS
    end

    it "has help info" do
      expect(gitnesse("help pull")).to eq help
    end
  end
end
