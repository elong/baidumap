module Baidumap
  module Request
    class Direction
      include Baidumap::Request

      def direct_by_car( ori, dest, region )
        derection({ origin_region:region, destination_region:region,
                      origin:ori, destination:dest,mode:'driving'})
      end

      def direct_by_bus( ori, dest, region )
        derection({ region:region, origin:ori,
                       destination:dest,mode:'transit'})
      end

      def direct_on_foot( ori, dest, region)
        derection({ region:region, origin:ori,
                       destination:dest,mode:'walking'})
      end

      private
      def direction(params)
        act(__method__,params,'v1')
      end
    end
  end
end