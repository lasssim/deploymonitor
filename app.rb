require 'rubygems'

require 'sinatra'

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
    state = request_payload["state"]
    ap state
    if state == "success"
      puts `./dockerize.sh`
    end
  end
end
