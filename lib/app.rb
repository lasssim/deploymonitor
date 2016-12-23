class App < Sinatra::Base

  def body
    request.body.rewind
    request.body.read
  end


  get '/*' do
  end

  post '/*' do
    UseCase::UpdateContainer.new(body).run
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
