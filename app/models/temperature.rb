# frozen_string_literal: true

# Model to keep temperatures
class Temperature < ApplicationRecord
  def current_temp(postcode)
    pcaws_output = PostCodeAndWeatherService.new.process(postcode)
    return process_pcaws_fail(pcaws_output, postcode) unless pcaws_output[:status] == 'ok'

    process_pcaws_pass(pcaws_output)
  end

  private

  def process_pcaws_fail(pcaws_output, postcode)
    case pcaws_output[:status]
    when 'invalid_postcode'
      "Sorry - #{postcode} doesn't appear to be a valid UK postcode. Please try again."
    when 'fail_weather'
      "Sorry - we can't get the weather for #{pcaws_output[:postcode]} right now. Please try again later."
    when 'fail_no_api'
      "Sorry - we have a fault and can't get the weather for #{pcaws_output[:postcode]} \
right now. Please try again later."
    end
  end

  def process_pcaws_pass(pcaws_output)
    word_to_use = process_temp(pcaws_output[:temp])
    "It is currently #{word_to_use} at #{pcaws_output[:postcode]}."
  end

  def process_temp(temp_as_text)
    temp = temp_as_text.to_f
    return 'cold' if temp < min_temp
    return 'hot' if temp > max_temp

    'warm'
  end
end
