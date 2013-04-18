require 'spec_helper'
require 'config_loader_helper'

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
          filename = "config/gitnesse.rb"
          Dir.should_receive(:glob).and_return([filename])
          File.should_receive(:read).with(filename).and_return(example_config_file)
          File.should_receive(:absolute_path).with(filename).and_return(filename)
          ConfigLoader.should_receive(:load).with(filename).and_return(true)
        end

        it "loads the config file" do
          expect(find_and_load.call).to be_true
        end
      end

      context "when multiple config files exist" do
        before do
          files = %w(config/lib/gitnesse.rb config/gitnesse.rb)
          Dir.should_receive(:glob).and_return(files)
          File.should_receive(:read).with("config/lib/gitnesse.rb").and_return(example_config_file)
          File.should_receive(:read).with("config/gitnesse.rb").and_return(example_config_file)
        end

        it "raises an error" do
          expect(find_and_load).to raise_error ConfigLoader::ConfigFileError
        end
      end
    end
  end
end
