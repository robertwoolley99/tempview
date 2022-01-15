# frozen_string_literal: true

require 'faraday/net_http'
class PostCodeCheckerService
  def check(postcode_input)
    Faraday.default_adapter = :net_http
    puts "https://api.postcodes.io/postcodes/#{postcode_input}"
    truncated_string = postcode_input.tr(' ','')
    Faraday.get("https://api.postcodes.io/postcodes/#{truncated_string}")
  end
end
