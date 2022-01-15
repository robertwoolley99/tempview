# frozen_string_literal: true

require 'faraday/net_http'
# Class which calls the Weather API to get the temperature
class WeatherService
  def forecast(api_key, postcode)
    Faraday.default_adapter = :net_http
    Faraday.get("#{WEATHER_URL}key=#{api_key}&q=#{postcode}")
  end
end
