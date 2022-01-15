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

    context 'when the postcode checker had failed for some reason' do
      it 'can cope with the postcode checker being down' do
        postcode_checker_site_is_down('W128QT')
        output = described_class.new.check('W12 8QT')
        expect(output).to eq('CANNOT_CHECK')
      end

      it 'can cope if the postcode checker is up but has other issues' do
        postcode_checker_up_but_not_working_properly('SW1H0BD')
        output = described_class.new.check('SW1H 0BD')
        expect(output).to eq('CANNOT_CHECK')
      end
    end
  end
end
