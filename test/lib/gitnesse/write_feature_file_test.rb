require_relative '../../test_helper'

describe Gitnesse::Features do
  describe ".write_feature_file" do
    let(:file) { StringIO.new }
    let(:file_path) { "#{Gitnesse.configuration.target_directory}/test.feature" }

    before do
      File.expects(:open).with(file_path, "w").yields(file)
      Gitnesse::Features.expects(:gather_features).with({ "test-feature" => "feature content" }).returns("feature content")
    end

    it "writes to the file" do
      Gitnesse::Features.write_feature_file(file_path, { "test-feature" => "feature content" })
      file.string.must_equal "feature content"
    end
  end
end
