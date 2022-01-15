# frozen_string_literal: true

module MockApis
  module PostCodeChecker
    @postcode_check_url = 'https://api.postcodes.io/postcodes'
    def return_successful_check(id)
      WebMock.stub_request(:get, "#{@postcode_check_url}/#{id}").to_return(
        { status: 200,
          body: File.read('spec/fixtures/postcode_checker/good_check_postcode.json'),
          headers: {} }
      )
    end
  end
end
