require 'spec_helper'

describe Gitnesse::FeatureExtractor do
  let(:expected_features) { [example_feature.chomp, another_example_feature.chomp] }
  let(:wiki_page_to_extract) { example_wiki_page }

  it "extracts Cucumber features from Markdown wiki pages" do
    extracted_page = Gitnesse::FeatureExtractor.extract!(example_wiki_page)
    expect(extracted_page).to eq expected_features
  end

  it "returns false if no examples were found" do
    expect(Gitnesse::FeatureExtractor.extract!("")).to be_false
  end
end
