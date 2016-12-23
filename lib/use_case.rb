require_relative 'use_case/update_container'

module UseCase
  module_function

  def configure(&block)
    @config = Confstruct::Configuration.new(&block)
  end

  def config
    @config || configure
  end

end
