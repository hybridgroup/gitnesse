require 'spec_helper'

describe Gitnesse do
  it "should have a version number string" do
    expect(Gitnesse::VERSION).to be_a String
  end
end
