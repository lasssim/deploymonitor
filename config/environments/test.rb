Dockerize.configure do 
  docker_url "unix:///var/run/docker.sock"
  logger Logger.new(STDOUT)
  tmp_dir_base "/tmp/dockerize"
  keep_nr_images 4
end

UseCase.configure do
  pushers ["lister"]
  repositories ["lister/docker-hello-world"]
  logger Logger.new(STDOUT)
end
