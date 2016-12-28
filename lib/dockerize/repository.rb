module Dockerize
  class Repository
    attr_reader :name
    def initialize(repository_hash)
      @name = repository_hash.fetch("full_name")
    end

    def clone_url
      "https://github.com/#{name}.git"
    end
  end

end
