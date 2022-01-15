# frozen_string_literal: true

require 'faraday/net_http'
# Class which calls an API to check postcodes
class PostCodeCheckerService
  def check(postcode_input)
    truncated_string = postcode_input.tr(' ', '')
    call_postcodes_io(truncated_string)
  end

  def call_postcodes_io(truncated_string)
    Faraday.default_adapter = :net_http
    response = Faraday.get("#{POST_CODE_CHECK_URL}#{truncated_string}")
    return 'NOT_VALID' if response.status == 404
    response_hash = JSON.parse(response.body)
    result_hash = response_hash['result']
    result_hash['postcode']
  end
end
