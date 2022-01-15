# frozen_string_literal: true

# Class which takes a call from the model and manages postcode checker and weather
class PostCodeAndWeatherService
  def process(postcode)
    return 'ERROR:NIL' if postcode.nil?
    api_key = ENV['WEATHER_API_KEY']
    return 'ERROR:NO_API_KEY' if api_key.nil?
  end
end
