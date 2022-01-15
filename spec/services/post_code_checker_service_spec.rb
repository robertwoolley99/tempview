# frozen_string_literal: true
require 'rails_helper'
require 'webmock/rspec'

RSpec.describe PostCodeCheckerService do
  include MockApis::PostCodeChecker
  context 'when correct requests are made' do
    it 'calls the correct URL' do
      return_successful_check('RH28HR')
      PostCodeCheckerService.new.check('RH2 8HR')
      expect(WebMock).to have_requested(:get, 'https://api.postcodes.io/postcodes/RH28HR')
    end
  end
end
