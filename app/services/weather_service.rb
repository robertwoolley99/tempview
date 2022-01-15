# frozen_string_literal: true

require 'faraday/net_http'
# Class which calls the Weather API to get the temperature
class WeatherService
  def forecast(api_key, postcode)
    Faraday.default_adapter = :net_http
    begin
      response = Faraday.get("#{WEATHER_URL}key=#{api_key}&q=#{postcode}")
    rescue StandardError
      return 'FAIL'
    end
    return process_valid_response(response.body) if response.status == 200

    'FAIL'
  end

  private

  def process_valid_response(body)
    response_hash = JSON.parse(body)
    temp_as_float = response_hash.dig 'current', 'temp_c'
    format('%.1f', temp_as_float)
  end
end
