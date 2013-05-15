require 'spec_helper'

module Gitnesse
  describe ConfigLoader do
    let(:config) { Config.instance }

    describe "#find_and_load" do
      let(:find_and_load) { -> { ConfigLoader.find_and_load } }

      context "when no config file exists" do
        before do
          Dir.should_receive(:glob).and_return([])
        end

        it "raises an error" do
          expect(find_and_load).to raise_error ConfigLoader::ConfigFileError
        end
      end

      context "when one config file exists" do
        before do
          files = [Support.example_config_file_path]
          Dir.should_receive(:glob).and_return(files)
          ConfigLoader.should_receive(:load).and_return(true)
        end

        it "loads the config file" do
          expect(find_and_load.call).to be_true
        end
      end

      context "when multiple config files exist" do
        before do
          files = [Support.example_config_file_path, Support.example_config_file_path]
          Dir.should_receive(:glob).and_return(files)
        end

        it "raises an error" do
          expect(find_and_load).to raise_error ConfigLoader::ConfigFileError
        end
      end
    end
  end
end
