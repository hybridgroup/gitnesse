require_relative '../../test_helper'

describe Gitnesse do
  describe "#write_feature_file" do
    let(:method) { lambda { Gitnesse.write_feature_file } }
    let(:file) { StringIO.new }

    before do
      File.expects(:open).with("#{Gitnesse.target_directory}/test.feature", "w").yields(file)
      Gitnesse.expects(:gather_features).with({ "test-feature" => "feature content" }).returns("feature content")
    end

    it "writes to the file" do
      Gitnesse.write_feature_file("test", { "test-feature" => "feature content" })
      file.string.must_equal "feature content"
    end
  end
end
