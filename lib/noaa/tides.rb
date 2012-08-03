
require 'faraday'

module Noaa
  class Tides
    HOST = 'http://tidesandcurrents.noaa.gov'
    URL_BASE = '/noaatidepredictions/NOAATidesFacade.jsp?datatype=Annual+TXT&timelength=daily&dataUnits=1&timeUnits=2&pageview=dayly&print_download=true'

    def self.get_tides(station,start)
      #url = URL_BASE + station.getApiUrlParams() + "&year=" + new SimpleDateFormat("yyyy").format(begin) + "&bdate=" + new SimpleDateFormat("yyyy").format(begin) + "0101";
      url = "#{URL_BASE}#{station.url_params}&year=#{start.strftime('%Y')}&bdate=#{start.strftime('%Y')}0101"
      puts ">>>>>>>>>>>>>> #{HOST}#{url}"
      conn = Faraday.new(:url => HOST) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
      response = conn.get(url)
      puts response.body
    end
  end
end