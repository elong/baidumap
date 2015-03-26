module Baidumap
  module Request
    class Geocoder
      include Baidumap::Request
      #地理编码, 把地址变成经纬度
      def encode(address,city)
        act('',{'address'=>address,'city'=>city},'v2')
      end
      #逆地理编码, 把经纬度变成地址
      def decode(lng,lat)
        act('',{'location'=>"#{lng},#{lat}"},'v2')
      end
    end
  end
end
