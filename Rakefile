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

  task :fetch_bus,:ak do |task, args|
    ak = args[:ak]
    fetch( ak, :bus, "公交车站" )
  end

  task :fetch_metro,:ak do |task, args|
    ak = args[:ak]
    fetch( ak, :metro, "地铁" )
  end

  task :fetch_cafe,:ak do |task, args|
    ak = args[:ak]
    fetch( ak, :cafe, "餐饮" )
  end

  task :fetch_bank,:ak do |task, args|
    ak = args[:ak]
    fetch( ak, :bank, "银行" )
  end

  task :fetch_spot,:ak do |task, args|
    ak = args[:ak]
    fetch( ak, :spot, "景点" )
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
          p "click"
          if queue.length < 0.5*queue_length
            p "fetching #{column.to_s}"
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
        # wait for monitor
        sleep(1.second)
        begin 
          while work = queue.pop()
            raise "Works finished" if work == nil
            begin
              p "Fetching : " + work[:name].force_encoding('utf-8')
              # define a function here.
              work[ column ] = search( ak, keyword, work[:lat], work[:lng] )
              work.save 
            rescue => e
              puts "Errors encoutered when loading : #{work}"
              puts e
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
    """
    given ak, query keyword, lat lng
    execute radius place search
    delete street_id and uid in result
    """
    radius = 1000
    last_num_of_result = -1
    while true
      result = Baidumap::Request::Place.new(ak).search_by_radius( keyword,lat,lng,radius)
      result = result.result
      num_of_result = result.length
      # check if enough
      if radius > 3000 || num_of_result > 5
        break
      else
        p "insufficient result from #{keyword} :" + num_of_result.to_s
        radius += 1000
        last_num_of_result = num_of_result
      end
    end

    # delete street_id and uid to compress result 
    result.each do |unit|
      unit.delete("street_id")
      unit.delete("uid")
    end
    return result.to_json
  end

end # name space

