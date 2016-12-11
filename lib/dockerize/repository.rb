module Dockerize
  class Repository
    attr_reader :name, :clone_url
    def initialize(repository_hash)
      @name      = repository_hash.fetch("full_name")
      @clone_url = repository_hash.fetch("clone_url")
    end
  end

end
