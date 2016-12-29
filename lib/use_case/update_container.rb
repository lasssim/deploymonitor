module UseCase

  class UpdateContainer

    attr_reader :body, :logger

    def initialize(body, logger: UseCase.config.logger)
      @body = body
      @logger = logger
    end

    def run
      raise ArgumentError.new("State <#{state}> not handled") unless state_handled?
      raise ArgumentError.new("Respository <#{repository.name}> not allowed") unless repository_allowed?
      raise ArgumentError.new("Sender <#{sender.name}> not allowed") unless sender_allowed?

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
        logger: logger,
        docker_opts: repository_config["docker_opts"]
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
      repository_config["allowed_senders"].include?(sender.name) 
    end

    def repository_allowed?
      repository_config != nil
    end


    def state
      parsed_body["state"] 
    end

    def state_handled?
      state == "success"
    end

    def repository_config
      @repository_config ||= UseCase.config.repositories.find do |repo_config|
        repo_config["name"] == parsed_body["repository"]["full_name"]
      end
    end

  end

end

