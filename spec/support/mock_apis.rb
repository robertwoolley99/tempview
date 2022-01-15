# frozen_string_literal: true

module MockApis
  module PostCodeChecker
    POSTCODECHECKURL = 'https://api.postcodes.io/postcodes'
    def return_successful_check(id)
      WebMock.stub_request(:get, "#{POSTCODECHECKURL}/#{id}").to_return(
        { status: 200,
          body: File.read('spec/fixtures/postcode_checker/good_check_postcode.json'),
          headers: {} }
      )
    end

    def return_failed_postcode(id)
      WebMock.stub_request(:get, "#{POSTCODECHECKURL}/#{id}").to_return(
        { status: 404 }
      )
    end
  end
end
