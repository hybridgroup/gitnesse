require 'spec_helper'

module Gitnesse
  describe DependencyChecker do
    let(:checker) { DependencyChecker.new }
    let(:config)  { Config.instance }

    describe "#check" do
      it "calls other dependency checks" do
        checks = %w(check_git check_cucumber check_repository_url
                    check_identifier check_features_dir_exists)
        checks.each do |check|
          checker.should_receive(check.to_sym).and_return(true)
        end

        checker.check
      end

      it "calls display_errors if there are any errors" do
        checks = %w(check_cucumber check_repository_url check_identifier
                    check_features_dir_exists)

        checks.each do |check|
          checker.should_receive(check.to_sym).and_return(true)
        end

        checker.should_receive(:system).with('git --version &> /dev/null').and_return(nil)
        checker.should_receive(:display_errors)

        checker.check
      end
    end

    describe "#display_errors" do
      before do
        checker.instance_variable_set(:@errors, ["this is an example error"])

        checker.should_receive(:puts).with("Configuration errors were found!")
        checker.should_receive(:puts).with("  - this is an example error")
        checker.should_receive(:abort)
      end

      it "prints a note saying errors were found" do
        checker.display_errors
      end

      it "displays every error in @errors" do
        checker.display_errors
      end

      it "should exit" do
        checker.display_errors
      end
    end

    describe '#check_git' do
      context 'when git is installed' do
        before do
          checker.should_receive(:system).with('git --version &> /dev/null').and_return(true)
        end

        it 'returns true' do
          expect(checker.check_git).to be_true
        end
      end

      context 'when git is not installed' do
        before do
          checker.should_receive(:system).with('git --version &> /dev/null').and_return(nil)
        end

        it 'adds an error' do
          expect {
            checker.check_git
          }.to change{checker.errors.length}.from(0).to(1)
        end
      end
    end

    describe '#check_cucumber' do
      context 'when cucumber is installed' do
        before do
          checker.should_receive(:system).with('cucumber --version &> /dev/null').and_return(true)
        end

        it 'returns true' do
          expect(checker.check_cucumber).to be_true
        end
      end

      context 'when cucumber is not installed' do
        before do
          checker.should_receive(:system).with('cucumber --version &> /dev/null').and_return(nil)
        end

        it 'adds an error' do
          expect {
            checker.check_cucumber
          }.to change{checker.errors.length}.from(0).to(1)
        end
      end
    end

    describe "#check_repository_url" do
      context "when repository_url is set" do
        before do
          config.repository_url = "git@github.com:hybridgroup/gitnesse.wiki.git"
        end

        it "returns true" do
          expect(checker.check_repository_url).to be_true
        end
      end

      context "when repository_url is not set" do
        before do
          config.repository_url = nil
        end

        it "adds an error" do
          expect {
            checker.check_repository_url
          }.to change{checker.errors.length}.from(0).to(1)
        end
      end
    end


    describe "#check_identifier" do
      context "when annotate_results is true" do
        before do
          config.annotate_results = true
        end

        context "when identifier is set" do
          before do
            config.identifier = "Uncle Bob's Macbook Pro"
          end

          it "returns true" do
            expect(checker.check_identifier).to be_true
          end
        end

        context "when identifier is not set" do
          before do
            config.identifier = nil
          end

          it "adds an error" do
            expect {
              checker.check_identifier
            }.to change{checker.errors.length}.from(0).to(1)
          end
        end
      end

      context "when annotate_results is false" do
        before do
          config.annotate_results = false
        end

        it "returns true" do
          expect(checker.check_identifier).to be_true
        end
      end
    end

    describe "#check_features_dir_exists" do
      context "when features_dir exists" do
        before do
          File.should_receive(:directory?).and_return(true)
        end

        it "returns true" do
          expect(checker.check_features_dir_exists).to be_true
        end
      end

      context "when features_dir does not exist or is a file" do
        before do
          File.should_receive(:directory?).and_return(false)
        end

        it "adds an error" do
          expect {
            checker.check_features_dir_exists
          }.to change{checker.errors.length}.from(0).to(1)
        end
      end
    end
  end
end
