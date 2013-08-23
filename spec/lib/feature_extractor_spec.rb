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
  end
end
