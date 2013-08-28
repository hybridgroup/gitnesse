require 'spec_helper'

module Gitnesse
  describe Feature do
    let(:feature) { Feature.new "thing.feature" }
    let(:nested_feature) { Feature.new "nested_features/thing.feature" }

    it "accepts a filename as an argument" do
      expect(feature.filename).to eq "thing.feature"
    end

    it "can generate a wiki filename" do
      expect(feature.wiki_filename).to eq "features > thing.feature.md"
    end

    describe "#wiki_filename" do
      it "generates wiki filenames for nested features" do
        expect(nested_feature.wiki_filename).to eq "features > nested_features > thing.feature.md"
      end
    end

    describe "#read" do
      before do
        expect(File).to receive(:read).once.with("features/thing.feature").and_return('')
      end

      it "reads and caches the content of the file" do
        expect(feature.read).to be_a String
        expect(feature.read).to eq ''
      end
    end

    describe "#write" do
      before do
        @stringio = StringIO.new
        expect(File).to receive(:open).with("features/thing.feature", "w").and_yield(@stringio)
        allow(File).to receive(:read).with("features/thing.feature").and_return(@stringio.string)
      end

      it "writes content to the file" do
        feature.write('testing')
        expect(feature.read).to eq "testing"
      end
    end

    describe "#index_page" do
      it "generates the path to the index page the feature will appear on" do
        expect(feature.index_page).to eq "features.md"
        expect(nested_feature.index_page).to eq "features > nested_features.md"
      end
    end
  end
end
