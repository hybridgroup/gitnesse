require 'spec_helper'
require 'gitnesse/cli'

module Gitnesse
  describe Cli, type: :cli do
    let(:overview) do
      <<-EOS
USAGE: gitnesse <task> [<args>]

The gitnesse tasks are:
  cleanup   Cleans up project folders in ~/.gitnesse
  info      Prints current Gitnesse configuration
  pull      Pulls features from remote git-based wiki
  push      Pushes local features to remote git-based wiki
  run       Pulls changes from remote git-based wiki, and runs Cucumber.

See 'gitnesse help <task>' for more information on a specific task.
      EOS
    end

    it 'displays help overview when called with no args' do
      expect(gitnesse("")).to eq overview
    end

    it 'displays help overview when help task is called with no arguments' do
      expect(gitnesse("help")).to eq overview
    end

    context "when no help text for a given topic is available" do
      it "prints out a message" do
        expect(gitnesse("help missing")).to eq "No help for task 'missing'\n"
      end
    end
  end
end
