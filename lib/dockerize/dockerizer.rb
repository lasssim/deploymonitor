module Dockerize
  
  class Dockerizer
    attr_reader :worker
    def initialize(worker)
      @worker = worker
      Docker.url = 'tcp://192.168.11.108:4243'
      dockerize
    end

    def dockerize
      worker.work do 
        Docker::Image.build_from_dir('.') do |v|
          if (log = JSON.parse(v)) && log.has_key?("stream")
            $stdout.puts log["stream"]
          end
        end
      end
    end
  end

end


