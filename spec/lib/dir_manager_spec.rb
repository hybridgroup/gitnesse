require 'spec_helper'

module Gitnesse
  describe DirManager do
    let(:path) { "#{Dir.home}/.gitnesse/gitnesse" }

    describe ".make_project_dir" do
      before do
        FileUtils.should_receive(:mkdir_p).with(path).and_return(true)
      end

      it "creates a dir based on the current project name" do
        expect(DirManager.make_project_dir).to eq path
      end
    end

    describe ".remove_project_dir" do
      it "removes the wiki dir for the current project" do
        FileUtils.should_receive(:rm_rf).with(path).and_return(true)
        DirManager.remove_project_dir
      end
    end

    describe ".project_dir_present?" do
      context "if project dir is a directory" do
        before do
          File.should_receive(:directory?).with(path).and_return(true)
        end

        it "returns true" do
          expect(DirManager.project_dir_present?).to be_true
        end
      end

      context "if project dir does not exists" do
        before do
          File.should_receive(:directory?).with(path).and_return(false)
        end

        it "returns false" do
          expect(DirManager.project_dir_present?).to be_false
        end
      end
    end
  end
end
