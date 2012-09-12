
require 'faraday'

module Noaa
  class Tides
    HOST = 'http://tidesandcurrents.noaa.gov'
    URL_BASE = '/noaatidepredictions/NOAATidesFacade.jsp?datatype=Annual+TXT&timelength=daily&dataUnits=1&timeUnits=2&pageview=dayly&print_download=true'

    def self.check_for_cached_results(station,start)
      results = CachedTide.all(:station => station)
      return nil if results.length == 0
      if results.length > 0
        processed = {}
        results.each do |row|
          processed[row.date] ||= []
          processed[row.date] << {:time => row.time_of_day, :height => row.height.to_f, :low => row.is_low_tide}
        end
        return processed
      end
    end

    def self.get_tides(station,start)
      results = self.check_for_cached_results(station,start)
      return results unless results.nil?

      #url = URL_BASE + station.getApiUrlParams() + "&year=" + new SimpleDateFormat("yyyy").format(begin) + "&bdate=" + new SimpleDateFormat("yyyy").format(begin) + "0101";
      url = "#{URL_BASE}#{station.url_params}&year=#{start.strftime('%Y')}&bdate=#{start.strftime('%Y')}0101"
      conn = Faraday.new(:url => HOST) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
      processed = {}
      response = conn.get(url)
      response.body.split(/\r\n/).each do |line|
        next if line[0] != '2'
        date, dow, time, ampm, height, height_cm, low_or_high = line.split(' ')
        cached_tide = CachedTide.new(
          :station => station,
          :date => date,
          :time_of_day => time + ampm,
          :height => height,
          :is_low_tide => low_or_high == 'L',
          :updated_at => Time.now
        )
        if cached_tide.save
          processed[date] ||= []
          processed[date] << {:time => time+ampm, :height => height, :low => low_or_high == 'L'}
        else
          cached_tide.errors.each do |e|
            puts ">>> ERROR SAVING CACHED_TIDE >>> #{e}"
          end
        end
      end
      return processed
    end
  end
end