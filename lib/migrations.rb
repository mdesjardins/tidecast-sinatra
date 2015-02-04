
#UNUSED

require 'dm-migrations/migration_runner'

DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://mdesjardins:@localhost/tidecast_development')

DataMapper.logger.debug( "Starting Migration" )

migration 1, :create_states_table do
  up do
    create_table :states do
      column :id, Integer, :serial => true
      column :abbrev, String
      column :full_name, String
    end
  end

  down do
    drop_table :states
  end
end

migration 2, :create_regions_table do
  up do
    create_table :regions do
      column :id, Integer, :serial => true
      column :state_id, Integer
      column :name, String
    end
  end

  down do
    drop_table :states
  end
end

migration 3, :create_stations_table do
  up do
    create_table :stations do
      column :id, Integer, :serial => true
      column :state_id, Integer
      column :region_id, Integer
      column :station_code, String
      column :sec_station_code, String
      column :longitude, Float
      column :latitude, Float
      column :name, String
      column :thh, String
      column :thm, String
      column :ths, String
      column :tlh, String
      column :tlm, String
      column :tls, String
      column :hh, String
      column :hl, String
      column :legacy_id, String
      column :timezone, String
      column :zone, String
      column :nws_office, String
      column :enabled, Integer
    end
  end

  down do
    drop_table :stations
  end
end

migration 4, :create_forecast_urls do
  up do
    create_table :forecast_urls do
      column :id, Integer, :serial => true
      column :nws_office, String
      column :url, String
    end
  end

  down do
    drop_table :forecast_urls
  end
end

migration 5, :create_cached_tides do
  up do
    create_table :cached_tides do
      column :id, Integer, :serial => true
      column :station_id, Integer
      column :date, Date
      column :time_of_day, String
      column :height, Decimal, :precision => 8, :scale => 2
      column :is_low_tide, Boolean
      column :updated_at, DateTime
    end
  end

  down do
    drop_table :cached_tides
  end
end

if $0 == __FILE__
  if $*.first == "down"
    migrate_down!
  else
    migrate_up!
  end
end