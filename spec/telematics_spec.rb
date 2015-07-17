require 'spec_helper'
describe Baidumap::Request::Telematics do
  subject{Baidumap::Request::Telematics.new($ak)}
  it "should get navigation between cities" do
    p subject.navigation('北京','天津','北京','天津')
  end
end
