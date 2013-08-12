require 'spec_helper'

module Gitnesse
  describe DirManager do
    let(:path) { Dir.home }

    describe ".make_project_dir" do
      before do
        FileUtils.should_receive(:mkdir_p).with("#{path}/.gitnesse/gitnesse").and_return(true)
      end

      it "creates a dir based on the current project name" do
        expect(DirManager.make_project_dir).to eq "#{path}/.gitnesse/gitnesse"
      end
    end

    describe ".remove_project_dir" do
      it "removes the wiki dir for the current project" do
        FileUtils.should_receive(:rm_rf).with("#{path}/.gitnesse/gitnesse").and_return(true)
        DirManager.remove_project_dir
      end
    end
  end
end
