require File.dirname(__FILE__) + '/../spec_helper.rb'

describe Numeric do
  it "should generate am and pm times" do
    3.am.to_s.should eql(Time.parse("3:00:00").to_s)
    3.pm.to_s.should eql(Time.parse("15:00:00").to_s)
    19.am.to_s.should eql(Time.parse("19:00:00").to_s)
  end
end
