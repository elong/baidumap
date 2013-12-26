require 'spec_helper'

describe Baidumap::Request::Geocoder do
  subject{Baidumap::Request::Geocoder.new($ak)}
  it "should be able to encode an address" do
    #{"location"=>{"lng"=>116.50138754387, "lat"=>39.982778249893}, "precise"=>1, "confidence"=>80, "level"=>"道路"}
    response = subject.encode('酒仙桥中路10号','北京')
    response.class.should == Baidumap::Response
    response.status.should == 0
    response.result.should have_key 'location'
  end

  it "should be able to decode a location" do
    #{"location"=>{"lng"=>116.32298703399, "lat"=>39.983424051248}, "formatted_address"=>"北京市海淀区中关村大街27号1101-08室", "business"=>"中关村,人民大学,苏州街", "addressComponent"=>{"city"=>"北京市", "district"=>"海淀区", "province"=>"北京市", "street"=>"中关村大街", "street_number"=>"27号1101-08室"}, "cityCode"=>131}
    response = subject.decode('39.983424','116.322987')
    response.class.should == Baidumap::Response
    response.status.should == 0
    response.result.should have_key 'formatted_address'
  end
end