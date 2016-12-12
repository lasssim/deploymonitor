module Dockerize
  
  class Dockerizer
    attr_reader :worker, :docker_url, :keep_nr_images, :tags
    def initialize(worker:, docker_url: "unix:///var/run/docker.sock", logger: Logger.new(STDOUT), keep_nr_images: 4)
      @worker = worker
      @logger     = logger
      @docker_url = docker_url
      @keep_nr_images = keep_nr_images
      @tags           = [version_from_repository]
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
      Docker::Image.all.each do |image|
        tags = Array(image.info["RepoTags"])
        if tags.find { |tag| tag.include?(name) }
          image.remove(force: true)
        end
      end
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

    def tag_string(tag)
      "#{worker.repository.name}:#{tag}"
    end

    def version_from_repository
      worker.work do
        File.read("VERSION").strip
      end
    end

  end

end


