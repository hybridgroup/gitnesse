require 'spec_helper'

describe Gitnesse::Config do
  let(:config) { Gitnesse::Config.instance }
  let(:default_config_hash) do
    {
      annotate_results: false,
      branch: 'master',
      commit_info: nil,
      features_dir: 'features',
      repository_url: nil
    }
  end

  it "is a singleton" do
    expect(Gitnesse::Config.instance).to eq config
    expect {Gitnesse::Config.new}.to raise_error NoMethodError
  end

  it "has default settings" do
    expect(config.branch).to eq 'master'
    expect(config.annotate_results).to be_false
    expect(config.features_dir).to eq 'features'
  end

  describe ".to_h" do
    it "returns a hash of config data" do
      expect(config.to_h).to eq default_config_hash
    end
  end

  describe ".setup" do
    it "allows for config values to be set" do
      Gitnesse::Config.config do
        annotate_results = true
      end

      expect(config.annotate_results).to be_true
    end
  end
end
