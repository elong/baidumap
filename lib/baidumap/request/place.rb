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

      def search_by_bounds(query,lat1,lng1,lat2,lng2)
        search({
          'query'=>query,
          'bounds'=>"#{lat1},#{lng1},#{lat2},#{lng2}"
        })
      end

      def search_by_radius(query,lat,lng,radius)
        search({
          'query'=>query,
          'location'=>"#{lat},#{lng}",
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