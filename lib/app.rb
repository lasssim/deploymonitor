class App < Sinatra::Base

  def request_payload
    @request_payload ||= begin 
      request.body.rewind
      JSON.parse request.body.read
    end
  end

  get '/*' do
    "Sinatra App"
  end

  post '/*' do
    ap request_payload
    state = request_payload["state"]
    ap state
    if state == "success"
      puts `./dockerize.sh`
    end
  end
end


#body = JSON.parse(str)
#
#repo = Dockerize::Repository.new(body["repository"])
#pusher = Dockerize::Pusher.new(body["pusher"])
#
#
#worker = Dockerize::Worker.new(repo)
#
#dockerizer = Dockerize::Dockerizer.new(worker)
#
#
