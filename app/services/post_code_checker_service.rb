# frozen_string_literal: true

require 'faraday/net_http'
# Class which calls an API to check postcodes
class PostCodeCheckerService
  def check(postcode_string)
    truncated_postcode_string = postcode_string.tr(' ', '')
    call_postcodes_io(truncated_postcode_string)
  end

  private

  def call_postcodes_io(truncated_postcode_string)
    Faraday.default_adapter = :net_http
    begin
      response = Faraday.get("#{POST_CODE_CHECK_URL}#{truncated_postcode_string}")
    rescue StandardError
      return 'CANNOT_CHECK'
    end
    return process_valid_response(response) if response.status == 200
    return 'NOT_VALID' if response.status == 404

    'CANNOT_CHECK'
  end

  def process_valid_response(response)
    response_hash = JSON.parse(response.body)
    response_hash.dig 'result', 'postcode'
  end
end
