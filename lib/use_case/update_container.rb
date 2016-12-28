module UseCase

  class UpdateContainer

    attr_reader :body, :logger

    def initialize(body, logger: UseCase.config.logger)
      @body = body
      @logger = logger
    end

    def run
      raise ArgumentError.new("State <#{state}> not handled") unless state_handled?
      raise ArgumentError.new("Sender <#{sender.name}> not allowed") unless sender_allowed?
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

    def sender
      @sender ||= Dockerize::Sender.new(parsed_body["sender"])
    end

    def sender_allowed?
      UseCase.config.senders.include?(sender.name) 
    end

    def repository_allowed?
      UseCase.config.repositories.include?(repository.name)
    end


    def state
      parsed_body["state"] 
    end

    def state_handled?
      state == "success"
    end



  end

end

