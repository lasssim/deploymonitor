module Dockerize
  class Pusher
    attr_reader :name
    def initialize(pusher_hash)
      @name = pusher_hash.fetch("name")
    end
  end

end
