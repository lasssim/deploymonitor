module GithubHooks
  module_function

  def sender_json
    '{
      "login": "lister"
    }'
  end

  def repository_json
    '{
      "full_name": "lister/docker-hello-world"
    }'
  end

  def master_lister(sender: "lister", full_name: "lister/docker-hello-world", state: "success")
    <<-eos
    {
      "state": "#{state}",
      "repository": {
        "full_name": "#{full_name}"
      },
      "sender": {
        "login": "#{sender}"
      }
    }
    eos

  end
end
