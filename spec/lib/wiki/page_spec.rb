require 'spec_helper'

module Gitnesse
  describe Wiki::Page do
    let(:page) { Wiki::Page.new("~/.gitnesse/gitnesse/features > new_features > new_feature.feature.md") }

    it "converts the filename to a local path" do
      expect(page.relative_path).to eq "./features/new_features"
    end

    it "extracts the feature filename" do
      expect(page.filename).to eq "new_feature.feature"
    end

    it "constructs the full local file path" do
      expect(page.path).to eq "./features/new_features/new_feature.feature"
    end

    describe "#content" do
      it "reads and caches the page's content" do
        File.should_receive(:read).with(page.wiki_path).once.and_return("test")

        expect(page.content).to be_a String
        expect(page.content).to eq "test"
      end
    end
  end
end
