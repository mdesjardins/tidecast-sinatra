DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://mdesjardins:@localhost/tidecast_dev')


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

  def url_params
    result = "&Stationid=#{self.legacy_id}"
    result << "&TimeOffsetHigh=#{self.thh}" if self.thh != 0
    result << "&TimeOffsetLow=#{self.tlm}" if self.tlm != 0
    if self.hh.present?
      if self.hh[0] != '-' && self.hh[0] != '+'
        result << "&HeightOffsetHigh=*#{self.hh}"
      else
        result << "&HeightOffsetHigh=#{self.hh}"
      end
    end
    if self.hl.present?
      if self.hl[0] != '-' && self.hl[0] != '+'
        result << "&HeightOffsetLow=*#{self.hl}"
      else
        result << "&HeightOffsetLow=#{self.hl}"
      end
    end
    result
  end
end

class ForecastUrl
  include DataMapper::Resource
  property :id, Serial
  property :nws_office, String
  property :url, String
end

class CachedTide
  include DataMapper::Resource
  belongs_to :station
  property :id, Serial
  property :date, Date
  property :time_of_day, String
  property :height, Decimal, :precision => 8, :scale => 2
  property :is_low_tide, Boolean
  property :updated_at, DateTime
end

DataMapper.finalize
DataMapper.auto_upgrade!
DataMapper::Model.raise_on_save_failure = true
