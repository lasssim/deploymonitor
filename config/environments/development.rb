NgrokTunnel.setup

Dockerize.configure do 
  docker_url "unix:///var/run/docker.sock"
  logger Logger.new(STDOUT)
  tmp_dir_base "/tmp/dockerize"
  keep_nr_images 4
end

UseCase.configure do
  senders ["lister"]
  repositories ["lister/stairlightsrb"]
  logger Logger.new(STDOUT)
end
