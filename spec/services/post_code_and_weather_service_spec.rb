# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostCodeAndWeatherService do
  context 'when there is a problem before we make any calls' do
    it 'throws a fail if a nil is passed' do
      pcaws = described_class.new.process(nil)
      expect(pcaws).to eq('FAIL:NIL')
    end

    it 'throws a fail if there is no API key set' do
      ENV.delete('WEATHER_API_KEY')
      pcaws = described_class.new.process('RH2 8HR')
      expect(pcaws).to eq('FAIL:NO_API_KEY')
    end
  end

  context 'when we have an issue with the postcode checker' do
    let(:pccs) { instance_double PostCodeCheckerService }
    let(:ws) { instance_spy WeatherService }

    before do
      ENV['WEATHER_API_KEY'] = 'weather_api_key'
      allow(PostCodeCheckerService).to receive(:new).and_return(pccs)
    end

    it 'returns an error if the postcode does not exist' do
      allow(pccs).to receive(:check).and_return('NOT_VALID')
      pcaws = described_class.new.process('POSTCODE_NOT_EXISTING')
      expect(pcaws).to eq('ERROR:POSTCODE_NOT_VALID')
    end

    it 'uses the unvalidated postcode if the postcode checker is down' do
      allow(pccs).to receive(:check).and_return('NOT_CHECKED')
      allow(WeatherService).to receive(:new).and_return(ws)
      described_class.new.process('SW1H 0BD')
      expect(ws).to have_received(:forecast).with('weather_api_key', 'SW1H 0BD')
    end
  end

  context 'when we have issues with the weather service' do
    let(:pccs) { instance_double PostCodeCheckerService }
    let(:ws) { instance_double WeatherService }

    before do
      ENV['WEATHER_API_KEY'] = 'weather_api_key'
      allow(PostCodeCheckerService).to receive(:new).and_return(pccs)
      allow(pccs).to receive(:check).and_return('SW1H 0BD')
      allow(WeatherService).to receive(:new).and_return(ws)
    end

    it 'weather service has failed' do
      allow(ws).to receive(:forecast).with('weather_api_key', 'SW1H 0BD').and_return('FAIL')
      pcaws = described_class.new.process('SW1H 0BD')
      expect(pcaws).to eq('FAIL:WEATHER_SERVICE_NOT_AVAILABLE')
    end
  end
end
