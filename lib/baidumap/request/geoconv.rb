module Baidumap
  module Request
    class Geoconv

      include Baidumap::Request

      def conv(  lngs, lats, from = 3, to = 5)
        
        raise 'length of lats not equals length of lngs'if lats.length != lngs.length        

        coords=''
        lats.length.times do |i|
          coords += "#{lngs[i]},#{lats[i]};"
        end
        coords = coords[0...-1]

        param = {}
        param['from'] = from
        param['to'] = to
        param['coords'] = coords
        act( '', param, 'v1')
      end

      # overwrite to avoid comma and semicolon being encoded
      def request
        http_segments = @segments.clone
        @params.each do |key,value|
          http_segments[key] = value
        end
        
        # avoid using URI.encode
        query = ''
        http_segments.each do |key, value|
          query += "&#{key}=#{value}"
        end
        query = query[1..-1]
        
        uri = URI::HTTP.build(
          :host => HOST,
          :path => @action_path,
          :query => query
        ).to_s
        result = JSON.parse(HTTParty.get(uri).parsed_response)
        Baidumap::Response.new(result,self)
      end

    end
  end
end
