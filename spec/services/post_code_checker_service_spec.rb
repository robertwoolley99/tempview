# frozen_string_literal: true

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe PostCodeCheckerService do
  include MockApis::PostCodeChecker
  context 'when correct requests are made' do
    it 'calls the correct URL' do
      return_successful_check('RH28HR')
      described_class.new.check('RH2 8HR')
      expect(WebMock).to have_requested(:get, 'https://api.postcodes.io/postcodes/RH28HR')
    end

    it 'returns the validated postcode' do
      return_successful_check('RH28HR')
      output = described_class.new.check('RH2      8HR')
      expect(output).to eq('RH2 8HR')
    end
    context 'when we send a junk postcode which cannot be resolved' do
      it 'manages junk postcodes correctly' do
        return_failed_postcode('A94E9H3')
        output = described_class.new.check('A94E9H3')
        expect(output).to eq('NOT_VALID')
      end
    end
  end
end
