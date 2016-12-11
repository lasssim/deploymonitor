module NgrokTunnel
  module_function

  def setup
    Ngrok::Tunnel.start(port: 8080)
    puts "+-------------------"
    puts "| #{Ngrok::Tunnel.ngrok_url}"
    puts "+-------------------"


    client = Octokit::Client.new(netrc: true)
    repo = "lister/stairlightsrb"
    client.edit_hook(repo, 9596053, "web", { url: Ngrok::Tunnel.ngrok_url, content_type: "json" })
  end
end


