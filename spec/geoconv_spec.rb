require 'spec_helper'

describe Baidumap::Request::Geoconv do
  subject{Baidumap::Request::Geoconv.new($ak)}
  it "should be able to encode an address" do
    lngs = [116.32298703399,116.42198703399]
    lats = [39.983424051248,32.983424051248]
    response = subject.conv(lngs,lats)
  end
end