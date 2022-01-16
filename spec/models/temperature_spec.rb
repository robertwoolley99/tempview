# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Temperature do
  describe 'current_temp method' do
    context 'when PCAWS returns errors correct text returned' do
      let(:pcaws_id) { instance_double PostCodeAndWeatherService }

      before { allow(PostCodeAndWeatherService).to receive(:new).and_return(pcaws_id) }

      it 'returns warning of incorrect postcode ' do
        allow(pcaws_id).to receive(:process).and_return({ status: 'invalid_postcode', postcode: 'BOGUS', temp: nil })
        output = described_class.new.current_temp('BOGUS_POSTCODE')
        expect(output).to eq("Sorry - BOGUS_POSTCODE doesn't appear to be a valid UK postcode. Please try again.")
      end

      it 'returns warning when the weather service is down.' do
        allow(pcaws_id).to receive(:process).and_return({ status: 'fail_weather', postcode: 'SW1H 0BD', temp: nil })
        output = described_class.new.current_temp('SW1H0BD')
        expect(output).to eq("Sorry - we can't get the weather for SW1H 0BD right now. Please try again later.")
      end

      it 'returns an error when api key is not set correctly' do
        allow(pcaws_id).to receive(:process).and_return({ status: 'fail_no_api', postcode: 'SW1H 0BD', temp: nil })
        output = described_class.new.current_temp('SW1H0BD')
        expect(output).to eq("Sorry - we have a fault and can't get the weather for SW1H 0BD right now. Please try again later.")
      end
    end
  end
end
