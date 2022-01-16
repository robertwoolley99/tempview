# frozen_string_literal: true

# Class which takes a call from the model and manages postcode checker and weather
class PostCodeAndWeatherService
  def process(postcode)
    return { status: 'fail_nil_postcode', postcode: postcode, temp: nil } if postcode.nil?

    @api_key = ENV['WEATHER_API_KEY']
    return { status: 'fail_no_api', postcode: postcode, temp: nil } if @api_key.nil?

    check_postcode(postcode)
  end

  private

  def check_postcode(postcode)
    checked_postcode = PostCodeCheckerService.new.check(postcode)
    return { status: 'invalid_postcode', postcode: postcode, temp: nil } if checked_postcode == 'NOT_VALID'

    if checked_postcode == 'NOT_CHECKED'
      get_weather(postcode)
    else
      get_weather(checked_postcode)
    end
  end

  def get_weather(postcode)
    weather = WeatherService.new.forecast(@api_key, postcode)
    return { status: 'fail_weather', postcode: 'SW1H 0BD', temp: nil } if weather == 'FAIL'

    weather
  end
end
