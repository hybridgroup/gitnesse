require 'spec_helper'

module Gitnesse
  describe DependencyChecker do
    let(:config) { Config.instance }

    describe "#check" do
      before do
        %w(check_git check_cucumber check_repository_url check_commit_info).each do |check|
          DependencyChecker.should_receive(check.to_sym).and_return(true)
        end
      end

      it "calls other dependency checks" do
        DependencyChecker.check
      end
    end

    describe "#check_git" do
      let(:check_git) { -> { DependencyChecker.check_git } }

      context "when git is installed" do
        before do
          DependencyChecker.should_receive(:system).with("git --version &> /dev/null").and_return(true)
        end

        it "returns true" do
          expect(check_git.call).to be_true
        end
      end

      context "when git is not installed" do
        before do
          DependencyChecker.should_receive(:system).with("git --version &> /dev/null").and_return(nil)
        end

        it "raises an error" do
          expect(check_git).to raise_error DependencyChecker::DependencyNotMetError
        end
      end
    end

    describe "#check_cucumber" do
      let(:check_cucumber) { -> { DependencyChecker.check_cucumber } }

      context "when cucumber is installed" do
        before do
          DependencyChecker.should_receive(:system).with("cucumber --version &> /dev/null").and_return(true)
        end

        it "returns true" do
          expect(check_cucumber.call).to be_true
        end
      end

      context "when cucumber is not installed" do
        before do
          DependencyChecker.should_receive(:system).with("cucumber --version &> /dev/null").and_return(nil)
        end

        it "raises an error" do
          expect(check_cucumber).to raise_error DependencyChecker::DependencyNotMetError
        end
      end
    end

    describe "#check_repository_url" do
      let(:check_repository_url) { -> { DependencyChecker.check_repository_url } }
      context "when repository_url is set" do
        before do
          config.repository_url = "git@github.com:hybridgroup/gitnesse.wiki.git"
        end

        it "returns true" do
          expect(check_repository_url.call).to be_true
        end
      end

      context "when repository_url is not set" do
        before do
          config.repository_url = nil
        end

        it "raises an error" do
          expect(check_repository_url).to raise_error DependencyChecker::DependencyNotMetError
        end
      end
    end

    describe "#check_commit_info" do
      let(:check_commit_info) { -> { DependencyChecker.check_commit_info } }

      context "when annotate_results is true" do
        before do
          Config.instance.annotate_results = true
        end

        context "when commit_info is set" do
          before do
            Config.instance.commit_info = "Uncle Bob's MacBook Pro"
          end

          it "returns true" do
            expect(check_commit_info.call).to be_true
          end
        end

        context "when commit_info is not set" do
          before do
            Config.instance.commit_info = nil
          end

          it "raises an error" do
            expect(check_commit_info).to raise_error DependencyChecker::DependencyNotMetError
          end
        end
      end

      context "when annotate_results is false" do
        before do
          Config.instance.annotate_results = false
        end

        it "returns true" do
          expect(check_commit_info.call).to be_true
        end
      end
    end
  end
end
