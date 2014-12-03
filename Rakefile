require "json"
require "yaml"
require "active_record"
require "bundler/gem_tasks"
require "./lib/baidumap"


config = YAML::load( File.open('db_config.yaml') )
ActiveRecord::Base.establish_connection( config )

class BaseAutonaviHotelPoi < ActiveRecord::Base
end


namespace :poi do

  task :fetch_bus do |ak|
    fetch( ak, "bus", "公交车站" )
  end

  task :fetch_metro do |ak|
    fetch( ak, "metor", "地铁" )
  end

  task :fetch_cafe do |ak|
    fetch( ak, "cafe", "餐饮" )
  end

  task :fetch_bank do |ak|
    fetch( ak, "bank", "银行" )
  end

  task :fetch_spot do |ak|
    fetch( ak, "spot", "景点" )
  end

  #####################
  # Helper  functions #
  #####################
  def fetch( ak, column, keyword, max_num = 1000, thread_num = 5, queue_length = 400 )
    queue = []
    totally = 0

    # monitor thread
     monitor = Thread.new do 
      begin
        while true
          if queue.length < 0.5*queue_length
            condition = "#{column.to_s}=''"
            query = BaseAutonaviHotelPoi.where(condition).limit( queue_length )
            query.each do |record|
              queue << record
            end
            
            totally += query.length
            is_finished = ( totally>max_num && max>0 ) || query.length<queue_length
            if is_finished
              raise "Mission completed"
            end
          end # if queue is over shorted
          sleep( 1.second )
        end # while
      rescue => e
        p e
      end # try catch
    end


    # worker thread
    workers = (0..thread_num).map do 
      # start a new thread
      Thread.new do
        begin 
          while work = queue.pop()
            raise "Works finished" if work == nil
            begin
              p "Fetching : " + work[:name].force_encoding('utf-8')
              # define a function here.
              work[ column ] = search( ak, keyword, work[:lat], work[:lng] )
            rescue => e
              puts "Errors encoutered when loading : #{work}"
              puts e
            ensure
              work.save 
            end
          end
        rescue ThreadError
        end
      end 
    end # works.map
    # hold main thread 
    workers.map(&:join);
    monitor.join
 
  end

  def search( ak, keyword,lat,lng )
    radius = 1000
    last_num_of_result = 0
    while true
      result = Baidumap::Request::Place.new(ak).search_by_radius( keyword,lat,lng,radius)
      result = result.result
      p result.to_json.length
      num_of_result = result.length
      # check if enough
      if last_num_of_result == num_of_result || num_of_result > 5
        break
      else
        rsdius += 1000
        last_num_of_result = num_of_result
      end
    end
    result.to_json
  end

end # name space

