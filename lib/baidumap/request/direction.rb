module Baidumap
  module Request
    class Direction
      include Baidumap::Request

      def direct_by_car( ori, dest, region )
        response = direction({ origin_region:region, destination_region:region,
                             origin:ori, destination:dest,mode:'driving'})
        return [] unless response.status.to_i == 0
        return [] if response.result["routes"].nil?
        response.result["routes"].map do |r|
          {
            distance: r["distance"].to_i,
            duration: r["duration"].to_i,
            instruction: r["steps"].map{|item| remove_html_chars(item["instructions"])}
          }
        end
      end

      def direct_by_bus( ori, dest, region )
        response = direction({ region:region, origin:ori,
                       destination:dest,mode:'transit'})
        return [] unless response.status.to_i == 0
        return [] if response.result["routes"].nil?
        result = []
        response.result["routes"].each do |r|
          r["scheme"].each do |sc|
            result << {
              distance: sc["distance"].to_i,
              duration: sc["duration"].to_i,
              instruction: sc["steps"].map{|item| remove_html_chars(item[0]["stepInstruction"])}
            }
          end
        end
        result 
      end

      def direct_on_foot( ori, dest, region)
        response = direction({ region:region, origin:ori,
                       destination:dest,mode:'walking'})
        return [] unless response.status.to_i == 0
        return [] if response.result["routes"].nil?
        response.result["routes"].map do |r|
          {
            distance: r["distance"].to_i,
            duration: r["duration"].to_i,
            instruction: r["steps"].map{|item| remove_html_chars(item["instructions"])}
          }
        end
      end

      def act(params, version='')
        @action_path = File.join(@service_path,version)
        @params = params
        request
      end

      def remove_html_chars(s)
        return nil if s.nil?
        s.gsub(/<[\d\w\/\+\\\'\"\=\#\s]*>/,'')
      end

      private
      def direction(params)
        act(params,'v1')
      end
    end
  end
end
