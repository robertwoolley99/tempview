# frozen_string_literal: true

# Class which takes a call from the model and manages postcode checker and weather
class PostCodeAndWeatherService
  def process(postcode)
    return 'FAIL:NIL' if postcode.nil?
    api_key = ENV['WEATHER_API_KEY']
    return 'FAIL:NO_API_KEY' if api_key.nil?
    check_postcode(postcode)
  end

  private

  def check_postcode(postcode)
    checked_postcode = PostCodeCheckerService.new.check(postcode)
    return 'POSTCODE_NOT_VALID' if checked_postcode == 'NOT_VALID'
  end
end
