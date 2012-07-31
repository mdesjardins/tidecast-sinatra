require 'sinatra/base'
require "sinatra/json"
require 'data_mapper'
require 'dm-serializer'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'postgres://mdesjardins:@localhost/tidecast_development')

##### models

class State
  include DataMapper::Resource
  has n, :regions
  property :id, Serial
  property :abbrev, String
  property :full_name, String
end

class Region
  include DataMapper::Resource
  belongs_to :state
  property :id, Serial
  property :name, String
end

class Station
  include DataMapper::Resource
  belongs_to :state
  belongs_to :region
  property :id, Serial
  property :station_code, String
  property :sec_station_code, String
  property :longitude, Float
  property :latitude, Float
  property :name, String
  property :thh, String
  property :thm, String
  property :ths, String
  property :tlh, String
  property :tlm, String
  property :tls, String
  property :hh, String
  property :hl, String
  property :legacy_id, String
  property :timezone, String
  property :zone, String
  property :nws_office, String
  property :enabled, Integer
end

class ForecastUrl
  include DataMapper::Resource
  property :id, Serial
  property :nws_office, String
  property :url, String
end

DataMapper.finalize

##### app

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
  end

  get "/station/:station_id/forecast" do
  end

  run! if app_file == $0
end