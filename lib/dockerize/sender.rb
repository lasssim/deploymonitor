module Dockerize
  class Sender
    attr_reader :name
    def initialize(sender_hash)
      @name = sender_hash.fetch("login")
    end
  end

end
