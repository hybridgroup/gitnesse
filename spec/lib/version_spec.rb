require 'spec_helper'

module Gitnesse
  describe VERSION do
    it "should have a version number string" do
      expect(VERSION).to be_a String
    end
  end
end
