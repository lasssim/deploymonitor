module NgrokTunnel
  module_function

  def configure(hash={}, &block)
    @config = Confstruct::Configuration.new(hash, &block)
  end

  def config
    @config || configure
  end

  def logger
    config.logger
  end

  def log(str)
    return unless logger
    logger.info(str)
  end

  def setup
    Ngrok::Tunnel.start(port: config.app_port)
    log "+-------------------"
    log "| #{Ngrok::Tunnel.ngrok_url}"
    log "+-------------------"


    repositories.each do |name, github_hook_id|
      github_client.edit_hook(
        name, 
        github_hook_id,
        "web", 
        { url: Ngrok::Tunnel.ngrok_url, content_type: "json" }
      )
    end
  end

  def github_client
    @github_client ||= Octokit::Client.new(netrc: true)
  end

  def repositories
    config.repositories.map do |repo|
      [repo["name"], repo["github_hook_id"]]
    end
  end
end


