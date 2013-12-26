module Baidumap
  module Request
    class Place
      include Baidumap::Request

      def search_by_region(query,region)
        search({
          'query'=>query,
          'region'=>region
        })
      end

      def search_by_bounds(query,lng1,lat1,lng2,lat2)
        search({
          'query'=>query,
          'bounds'=>"#{lng1},#{lat1},#{lng2},#{lat2}"
        })
      end

      def search_by_radius(query,lng,lat,radius)
        search({
          'query'=>query,
          'location'=>"#{lng},#{lat}",
          'radius'=>radius
        })
      end

      def detail(uid)
        act(__method__,{'uid'=>uid})
      end

      def eventsearch
        "todo"
      end

      def eventdetail
        "todo"
      end

      private
      def search(params)
        act(__method__,params)
      end
    end
  end
end