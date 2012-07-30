require 'sinatra'

class App < Sinatra::Base
  get '/hi' do
    "Hello World!"
  end

  run! if app_file == $0
end
