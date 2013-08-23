require 'spec_helper'

module Gitnesse
  describe FeatureExtractor do
    let(:example_page) { Support.example_wiki_page }
    let(:expected_features) { Support.example_features }

    describe ".extract!" do
      it "extracts Cucumber features from Markdown wiki pages as an array" do
        extracted_page = FeatureExtractor.extract!(example_page)
        expect(extracted_page).to eq expected_features
        expect(extracted_page).to be_an Array
      end

      it "returns an empty array if no examples were found" do
        expect(FeatureExtractor.extract!("")).to eq []
      end
    end

    describe ".contains_features?" do
      it "returns true if the page contains features" do
        expect(FeatureExtractor.contains_features?(example_page)).to be_true
      end

      it "returns false if no features were found" do
        expect(FeatureExtractor.contains_features?("")).to be_false
      end
    end
  end
end
