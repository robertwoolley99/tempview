# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Temperature do
  context 'when PCAWS returns errors correct text returned' do
    let(:pcaws_id) { instance_double PostCodeAndWeatherService }

    before { allow(PostCodeAndWeatherService).to receive(:new).and_return(pcaws_id) }

    it 'returns warning of incorrect postcode ' do
      allow(pcaws_id).to receive(:process).and_return({ status: 'invalid_postcode', postcode: 'BOGUS', temp: nil })
      output = described_class.new.current_temp('BOGUS_POSTCODE')
      expect(output).to eq("Sorry - BOGUS_POSTCODE doesn't appear to be a valid UK postcode. \
Please try again with a valid UK postcode.")
    end

    it 'returns warning when the weather service is down.' do
      allow(pcaws_id).to receive(:process).and_return({ status: 'fail_weather', postcode: 'SW1H 0BD', temp: nil })
      output = described_class.new.current_temp('SW1H0BD')
      expect(output).to eq("Sorry - we can't get the weather for SW1H 0BD right now. Please try again later.")
    end

    it 'returns an error when api key is not set correctly' do
      allow(pcaws_id).to receive(:process).and_return({ status: 'fail_no_api', postcode: 'SW1H 0BD', temp: nil })
      output = described_class.new.current_temp('SW1H0BD')
      expect(output).to \
        eq("Sorry - we have a fault and can't get the weather for SW1H 0BD now. Please try again later.")
    end

    context 'when PCAWS returns correct information ' do
      let(:pcaws_id) { instance_double PostCodeAndWeatherService }

      before do
        temp = described_class.new
        temp.min_temp = 20.0
        temp.max_temp = 25.0
        temp.save
        allow(PostCodeAndWeatherService).to receive(:new).and_return(pcaws_id)
      end

      it 'returns cold when the temperature is below the min_temp' do
        allow(pcaws_id).to receive(:process).and_return({ status: 'ok', postcode: 'RH2 8HR', temp: '7.0' })
        output = described_class.last.current_temp('RH2 8HR')
        expect(output).to eq('It is currently cold at RH2 8HR.')
      end

      it 'returns hot when the temperature is above the max_temp' do
        allow(pcaws_id).to receive(:process).and_return({ status: 'ok', postcode: 'RH2 8HR', temp: '30.0' })
        output = described_class.last.current_temp('RH2 8HR')
        expect(output).to eq('It is currently hot at RH2 8HR.')
      end

      it 'returns warm when the temperature is equal to the min temp' do
        allow(pcaws_id).to receive(:process).and_return({ status: 'ok', postcode: 'RH2 8HR', temp: '20.0' })
        output = described_class.last.current_temp('RH2 8HR')
        expect(output).to eq('It is currently warm at RH2 8HR.')
      end
    end
  end
end
