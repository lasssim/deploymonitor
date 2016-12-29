path_to_config = File.expand_path("../../repositories.yml", __FILE__)
config_from_yml = YAML.load_file(path_to_config)[ENV['RACK_ENV'] || "development"]

logger = Logger.new(STDOUT)


Dockerize.configure do 
  docker_url     config_from_yml["docker_url"]
  keep_nr_images config_from_yml["keep_nr_images"]
  tmp_dir_base   "/tmp/dockerize"
  logger         logger
end

UseCase.configure do
  repositories config_from_yml["repositories"]
  logger       logger
end

NgrokTunnel.configure do
  app_port     config_from_yml["app_port"]
  repositories config_from_yml["repositories"]
  logger       logger
end
