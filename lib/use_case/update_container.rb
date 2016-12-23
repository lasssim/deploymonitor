module UseCase

  class UpdateContainer

    attr_reader :body, :logger

    def initialize(body, logger: UseCase.config.logger)
      @body = body
      @logger = logger
    end

    def run
      raise ArgumentError.new("Pusher <#{pusher.name}> not allowed") unless pusher_allowed?
      raise ArgumentError.new("Respository <#{repository.name}> not allowed") unless repository_allowed?

      dockerizer.image
      dockerizer.remove
      dockerizer.start

    end

    def repository
      @repository ||= Dockerize::Repository.new(parsed_body["repository"])
    end

    def dockerizer
      @dockerizer ||= Dockerize::Dockerizer.new(
        worker: worker,
        logger: logger
      )
    end

    def worker
      @worker ||= Dockerize::Worker.new(
        repository: repository,
        logger: logger
      )
    end


    private
    def parsed_body
      @parsed_body ||= JSON.parse(body)
    end

    def pusher
      @pusher ||= Dockerize::Pusher.new(parsed_body["pusher"])
    end

    def pusher_allowed?
      UseCase.config.pushers.include?(pusher.name) 
    end

    def repository_allowed?
      UseCase.config.repositories.include?(repository.name)
    end




  end

end

