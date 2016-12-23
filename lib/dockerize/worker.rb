module Dockerize
  class Worker
    attr_reader :repository, :logger

    def initialize(repository: , logger: Dockerize.config.logger)
      @repository = repository
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

    def self.clean_all
      FileUtils.rm_rf(tmp_dir_base) 
    end

    def self.tmp_dir_base
      File.join(Dockerize.config.tmp_dir_base, "dockerize")
    end
    private 

    def tmp_dir_base
      self.class.tmp_dir_base 
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

