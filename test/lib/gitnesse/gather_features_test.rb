require_relative '../../test_helper'

describe Gitnesse::Features do
  describe ".gather_features" do

    describe "when several features" do
      let(:page_features) { {"test-feature" => "feature content", "another-test-feature" => "another feature content"} }

      it { Gitnesse::Features.gather_features(page_features).must_equal "feature content" }
    end

    describe "when one single feature" do
      let(:page_features) { {"test-feature" => "feature content"} }

      it { Gitnesse::Features.gather_features(page_features).must_equal "feature content" }
    end

    describe "when no features" do
      let(:page_features) { Hash.new }

      it { Gitnesse::Features.gather_features(page_features).must_equal "" }
    end

    describe "when nil" do
      let(:page_features) { nil }

      it { Gitnesse::Features.gather_features(page_features).must_equal "" }
    end
  end
end
