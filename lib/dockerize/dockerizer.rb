module Dockerize
  
  class Dockerizer
    attr_reader :worker, :docker_url, :keep_nr_images, :tags, :docker_opts
    def initialize(worker:, docker_url: Dockerize.config.docker_url, logger: Dockerize.config.logger, keep_nr_images: Dockerize.config.keep_nr_images, docker_opts: {})
      @worker = worker
      @logger     = logger
      @docker_url = docker_url
      @keep_nr_images = keep_nr_images
      @tags           = [version_from_repository]
      @docker_opts    = Hash(docker_opts)
    end

    def image
      @image ||= begin
                   img = build_image
                   tags.push("latest").compact.uniq.each do |tag|
                     img.tag("repo" => worker.repository.name, "tag" => tag)
                   end
                   img
                 end
    end

    def clean_up
      nr_images_to_remove = images.size - keep_nr_images
      return unless nr_images_to_remove > 0
      images[0...nr_images_to_remove].each do |image|
        next if image.info["RepoTags"].include?(tag_string("latest"))
        image.remove
      end
    end

    def self.clean_all(name)

      Docker::Container.all(all: true).select do |c|
        c.info["Names"].include?("/#{name}")
      end.each do |c|
        c.stop
        c.remove(force: true)
      end


      Docker::Image.all.each do |image|
        tags = Array(image.info["RepoTags"])
        if tags.find { |tag| tag.include?(name) }
          image.remove(force: true)
        end
      end


      Worker.clean_all
    end

    def images
      latest = nil
      
      images = Docker::Image.all.select do |image|
        tags = Array(image.info["RepoTags"])
        if tags.include?(tag_string("latest"))
          latest = image
          false
        else
          !!tags.find { |tag| tag.include?(worker.repository.name) }
        end
      end

      images.sort! do |image_a, image_b|
        image_a.info["RepoTags"][0] <=> image_b.info["RepoTags"][0]
      end
      
      images = images << latest
      images.compact!
      images
    end

    def latest_image
      Docker::Image.all.find do |image|
        image.info["RepoTags"].include?(tag_string("latest"))
      end
    end

    def start
      container.start
    end

    def stop
      return unless running?
      container.stop
    end

    def remove
      container.stop
      container.remove
    end

    def state
      return nil unless find_container
      container.info["State"]
    end

    def running?
      state == "running"
    end

    private
    def build_image
      Docker.options[:read_timeout] = 600
      Docker.url = docker_url
      worker.work do 
        Docker::Image.build_from_dir('.') do |v|
          if (log = JSON.parse(v)) && log.has_key?("stream")
            logger.info log["stream"] if logger
          end
        end
      end
    end

    def logger
      @logger
    end

    def container
      find_container || create_container 
    end

    def find_container
      Docker::Container.all(all: true).find do |c|
        c.info["Names"].include?("/#{container_name}")
      end
    end

    def create_container
      hash = {
        "Image" => tag_string("latest"),
        "name"  => container_name
      }.merge(docker_opts)
      Docker::Container.create(hash)
    end

    def tag_string(tag)
      "#{worker.repository.name}:#{tag}"
    end

    def container_name
      worker.repository.name.split("/").last
    end

    def version_from_repository
      worker.work do 
        File.read("VERSION").strip
      end
    end

  end

end


