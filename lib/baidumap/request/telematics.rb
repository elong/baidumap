module Baidumap
  module Request
    class Telematics
      include Baidumap::Request

      def navigation(ori, dest, ori_region, dest_region)
        params = { origin: ori, destination: dest, origin_region: ori_region, destination_region: dest_region}
        response = act('navigation', params, 'v3')
        route = response.result[0] 
        return [] if route.nil?
        return [] unless route["retrunType"] != '20'
        {
          distance: route["distance"].to_i,
          duration: route["duration"].to_i,
          instruction: route["steps"].map{|item| remove_html_chars(item["instructions"])}
        }
      end
      def remove_html_chars(s)
        return nil if s.nil?
        s.gsub(/<[\d\w\/\+\\\'\"\=\#\s]*>/,'')
      end

    end
  end
end
