# frozen_string_literal true

# Model to keep temperatures
class Temperature < ApplicationRecord
  def current_temp(postcode)
    pcaws_output = PostCodeAndWeatherService.new.process(postcode)
    return "Sorry - that doesn't appear to be a valid UK postcode. Please try again."
  end
end
