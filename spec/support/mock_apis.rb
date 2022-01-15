# frozen_string_literal: true

module MockApis
  module PostCodeChecker
    def return_successful_check(id)
      WebMock.stub_request(:get, "#{POST_CODE_CHECK_URL}#{id}").to_return(
        { status: 200,
          body: File.read('spec/fixtures/postcode_checker/good_check_postcode.json'),
          headers: {} }
      )
    end

    def return_failed_postcode(id)
      WebMock.stub_request(:get, "#{POST_CODE_CHECK_URL}#{id}").to_return(
        { status: 404 }
      )
    end

    def postcode_checker_site_is_down(id)
      WebMock.stub_request(:get, "#{POST_CODE_CHECK_URL}#{id}").to_timeout
    end

    def postcode_checker_up_but_not_working_properly(id)
      WebMock.stub_request(:get, "#{POST_CODE_CHECK_URL}#{id}").to_return(
        { status: 500 }
      )
    end
  end
  module Weather
    def return_successful_weather(api_key, postcode)
      WebMock.stub_request(:get, "#{WEATHER_URL}key=#{api_key}&q=#{postcode}").to_return(
        { status: 200,
          body: File.read('spec/fixtures/weather/good_weather.json'),
          headers: {} }
      )
    end
  end
end
