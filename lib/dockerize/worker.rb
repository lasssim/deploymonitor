module Dockerize
  class Worker
    attr_reader :repository, :logger

    def initialize(repository: , logger: Logger.new(STDOUT))
      @repository = repository
      @tmp_dir_base = "/tmp/dockerize"
      @logger = logger
    end

    def work(&block)
      update
      git.chdir do
        block.call
      end
    end

    def clean_up
      FileUtils.rm_rf(tmp_dir)
    end

    def tmp_dir
      File.join(tmp_dir_base, repository.name)
    end

    private 

    def tmp_dir_base
      @tmp_dir_base 
    end

    def git
      @git ||= begin 
                 Git.open(tmp_dir, log: logger)
               rescue ArgumentError => ex
                 Git.clone(repository.clone_url, repository.name, path: tmp_dir_base, log: logger)
               end
    end

 
    def update
      git.pull
    end

   

  end

end

