require "json"
require "yaml"
require "active_record"
require "thread"
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
  def fetch( ak, column, keyword, max_num = 100, thread_num = 10, queue_length = 40 )
    # use queue instead of array to ensure thread safe
    queue_in = Queue.new
    queue_out = Queue.new
    totally = 0

    # reader thread
    reader = Thread.new do 
      begin
        while true
          if queue_in.length < 0.5*queue_length
            condition = "#{column.to_s}=''"
            query = BaseAutonaviHotelPoi.where(condition).limit( queue_length )
            query.each do |record|
              queue_in.push( record )
            end
            
            totally += query.length
            is_finished = ( totally>max_num && max_num>0 ) || query.length<queue_length
            raise "Mission completed" if is_finished
          end # if queue is over shorted
          sleep( thread_num*0.1 )
        end # while
      rescue => e
        p e
      end # try catch
    end

    # worker thread
    workers = (0..thread_num).map do 
      # start a new thread
      Thread.new do
        # wait for reader
        sleep( 1 )
        begin 
          # if queue_in is empty, it will raise error and end this thread
          while work = queue_in.pop()
            begin
              # define a function here.
              work[ column ] = search( ak, keyword, work[:lat], work[:lng] )
              queue_out.push( work )
            rescue => e
              puts "Errors encoutered!"
              puts e
            end
          end
        rescue ThreadError
        end
      end 
    end # works.map

    # writer thread
    writer = Thread.new do
      # wait for workers
      sleep(2)
      while true
        begin
          queue_out.pop.save
          # adaptive wrting rate
          sleep( 1.0/(queue_out.length+1) )
        rescue => e
          # todo: add error handling
        end
      end
    end

    # hold main thread 
    workers.map(&:join);
    reader.join
    writer.join
  end

  def search( ak, keyword, lat,lng, max_radius = 3000 )
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
      if radius > max_radius || num_of_result > 5
        break
      else
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

