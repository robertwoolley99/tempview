# frozen_string_literal: true


# Model to keep temperatures
class Temperature < ApplicationRecord
  def current_temp(postcode)
    pcaws_output = PostCodeAndWeatherService.new.process(postcode)
    case pcaws_output[:status]
    when 'invalid_postcode'
      "Sorry - #{postcode} doesn't appear to be a valid UK postcode. Please try again."
    when 'fail_weather'
      "Sorry - we can't get the weather for #{pcaws_output[:postcode]} right now. Please try again later."
    when 'fail_no_api'
      "Sorry - we have a fault and can't get the weather for #{pcaws_output[:postcode]} right now. Please try again later."
    end

  end
end
