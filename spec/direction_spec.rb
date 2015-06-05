require 'spec_helper'
describe Baidumap::Request::Direction do
  subject{Baidumap::Request::Direction.new($ak)}
  it "should be able to encode an address" do
    p subject.direct_by_bus('北京站|39.911900,116.433000','北京西站|39.902300,116.327000 ','北京')
  end
  it "should be 1" do
    p subject.direct_by_car('北京站|39.911900,116.433000','北京西站|39.902300,116.327000 ','北京')
  end
  it "should be 2" do
    p subject.direct_on_foot('北京站|39.911900,116.433000','北京西站|39.902300,116.327000 ','北京')
  end
end
