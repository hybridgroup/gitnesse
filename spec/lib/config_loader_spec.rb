require 'spec_helper'

module Gitnesse
  describe ConfigLoader do
    let(:config) { Config.instance }

    describe "#find_and_load" do
      context "when no config file exists" do
        before do
          expect(Dir).to receive(:glob).and_return []
          message = "Can't find a gitnesse.rb file with Gitnesse configuration."
          expect(ConfigLoader).to receive(:raise_error).with message
        end

        it "raises an error" do
          ConfigLoader.find_and_load
        end
      end

      context "when one config file exists" do
        before do
          files = [Support.example_config_file]
          expect(Dir).to receive(:glob).and_return(files)
          expect(ConfigLoader).to receive(:load).and_return(true)
          expect(ConfigLoader).to receive(:reject_irrelevant_files).and_return(files)
        end

        it "loads the config file" do
          ConfigLoader.find_and_load
        end
      end

      context "when multiple config files exist" do
        before do
          files = [Support.example_config_file, Support.example_config_file]
          expect(Dir).to receive(:glob).and_return(files)
          expect(ConfigLoader).to receive(:reject_irrelevant_files).and_return(files)
          expect(ConfigLoader).to receive(:raise_error).with("Multiple configuration files found:", files)
        end

        it "raises an error" do
          ConfigLoader.find_and_load
        end
      end
    end
  end
end
