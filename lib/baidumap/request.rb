require 'baidumap/request/place'
require 'baidumap/request/geocoder'
require 'httparty'
module Baidumap
  module Request
    HOST = 'api.map.baidu.com'
    def initialize(ak,pagesize=10,page_num=0,scope=1)
      service_name = self.class.name.split('::').last.downcase
      @service_path = "/#{service_name}/#{@version}"
      @ak = ak
      @segments = {:ak=>@ak,:output=>'json',:pagesize=>pagesize,:page_num => page_num,:scope=>scope}
    end

    #actions: search, detail, eventsearch, eventdetail
    def act(action,params, version='v2')
      @action_path = File.join(@service_path,action.to_s)
      # add support for version1
      @version = version
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
      result = JSON.parse(HTTParty.get(uri).parsed_response)
      Baidumap::Response.new(result,self)
    end
  end
end