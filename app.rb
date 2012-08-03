require 'sinatra/base'
require File.join(File.dirname(__FILE__), 'config', 'environment.rb')

class App < Sinatra::Base
  helpers Sinatra::JSON

  get '/hi' do
    "Hello World!"
  end

  get "/states" do
    State.all.to_json
  end

  get "/state/:state_id" do
    State.all(:id => params[:state_id]).to_json
  end

  get "/state/:state_id/regions" do
    Region.all(:state_id => params[:state_id]).to_json
  end

  get "/state/:state_id/stations" do
    Station.all(:state_id => params[:state_id]).to_json
  end

  get "/region/:region_id" do
    Region.all(:id => params[:region_id]).to_json
  end

  get "/region/:region_id/stations" do
    Station.all(:region_id => params[:region_id]).to_json
  end

  get "/station/:station_id" do
    Station.all(:id => params[:station_id]).to_json
  end

  get "/station/:station_id/tides" do
    Noaa::Tides.get_tides(Station.first(:id => params[:station_id]), Date.today)
  end

  get "/station/:station_id/forecast" do
  end

  run! if app_file == $0
end