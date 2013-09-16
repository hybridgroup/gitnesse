require 'spec_helper'

module Gitnesse
  describe Wiki do
    describe "#remove_features" do
      before do
        Wiki.any_instance.stub(:clone_or_update).and_return(true)

        @repo = double('repo', status: [])
        expect(Git).to receive(:init).with("~/.gitnesse/gitnesse").and_return(@repo)

        @wiki = Wiki.new "", "~/.gitnesse/gitnesse"
      end

      it "removes gitnesse-created files from the wiki" do
        files = [
            double(path: "Home.md"),
            double(path: "features.md"),
            double(path: "features > test.md"),
            double(path: "features > test > thing.feature.md")
        ]

        allow(@repo).to receive(:status).and_return(files)

        expect(@repo).to_not receive(:remove).with("Home.md")
        expect(@repo).to receive(:remove).with("features.md")
        expect(@repo).to receive(:remove).with("features > test.md")
        expect(@repo).to receive(:remove).with("features > test > thing.feature.md")

        @wiki.remove_features
      end
    end
  end
end
