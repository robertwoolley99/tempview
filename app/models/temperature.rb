# frozen_string_literal true

# Model to keep temperatures
class Temperature < ApplicationRecord
  def current_temp(postcode)
    PostCodeAndWeatherService.new.process(postcode)
  end
end
