require_relative "dockerize/pusher"
require_relative "dockerize/repository"
require_relative "dockerize/worker"
require_relative "dockerize/dockerizer"

module Dockerize

  module_function

  def configure(&block)
    @config = Confstruct::Configuration.new(&block)
  end

  def config
    @config || configure
  end
end
