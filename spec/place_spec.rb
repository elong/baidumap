require 'spec_helper'

describe Baidumap::Request::Place do
  subject{Baidumap::Request::Place.new($ak)}
  it "should be able to search by region" do
    response = subject.search_by_region('饭店','北京')
    response.class.should == Baidumap::Response
    response.status.should == 0
    result = response.result
    result.class.should == Array
    result.first.class.should == Hash
    result.first.should have_key 'name'
  end

  it "should be able to search by bounds" do
    response = subject.search_by_bounds('银行',39.915,116.404,39.975,116.414)
    response.class.should == Baidumap::Response
    response.status.should == 0
    result = response.result
    result.class.should == Array
    result.first.class.should == Hash
    result.first.should have_key 'name'
  end

  it "should be able to search by radius" do
    response = subject.search_by_radius('银行',39.915,116.404,2000)
    response.class.should == Baidumap::Response
    response.status.should == 0
    result = response.result
    result.class.should == Array
    result.first.class.should == Hash
    result.first.should have_key 'name'
  end
end