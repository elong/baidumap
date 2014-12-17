require 'baidumap/request/place'
require 'baidumap/request/geocoder'
require 'baidumap/request/geoconv'
require 'httparty'
module Baidumap
  module Request
    HOST = 'api.map.baidu.com'
    def initialize(ak,page_size=10,page_num=0,scope=1)
      service_name = self.class.name.split('::').last.downcase
      @service_path = "/#{service_name}/"
      @ak = ak
      @segments = {:ak=>@ak,:output=>'json',:page_size=>page_size,:page_num => page_num,:scope=>scope}
    end

    #actions: search, detail, eventsearch, eventdetail
    def act(action,params, version='')
      @action_path = File.join(@service_path,version,action.to_s)
      @params = params
      request
    end

    #next page
    def next
      @segments[:page_num] += 1
      request
    end

    #previous page
    def prev
      @segments[:page_num] -= 1
      request
    end

    private

    #send http request
    def request
      http_segments = @segments.clone
      @params.each do |key,value|
        http_segments[key] = value
      end
      uri = URI::HTTP.build(
        :host => HOST,
        :path => @action_path,
        :query => URI.encode_www_form(http_segments)
      ).to_s
      response = HTTParty.get(uri).parsed_response
      begin
        result = JSON.parse( response )
      rescue
        result = response
      end
      Baidumap::Response.new(result,self)
    end
  end
end