module Baidumap
  class Response
    attr_reader :status,:message,:total,:result
    def initialize(result,request)
      @status,@message,@total = result['status'],result['message'],result['total']
      @results = result['results']
      if result.has_key?'result'
        @result = result['result']
      elsif result.has_key?'results'
        @result = result['results']
      end
    end

    def next
      @request.next
    end

    def prev
      @request.prev
    end
  end
end