# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostCodeAndWeatherService do
  include MockApis::PostCodeChecker
  include MockApis::Weather
  context 'when there is a problem before we make any calls' do
    it 'throws a fail if a nil is passed' do
      pcaws = described_class.new.process(nil)
      expect(pcaws).to eq({ status: 'fail_nil_postcode', postcode: nil, temp: nil })
    end

    it 'throws a fail if there is no API key set' do
      ENV.delete('WEATHER_API_KEY')
      pcaws = described_class.new.process('RH2 8HR')
      expect(pcaws).to eq({ status: 'fail_no_api', postcode: 'RH2 8HR', temp: nil })
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
      expect(pcaws).to eq({ status: 'invalid_postcode', postcode: 'POSTCODE_NOT_EXISTING', temp: nil })
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
      expect(pcaws).to eq({ status: 'fail_weather', postcode: 'SW1H 0BD', temp: nil })
    end
  end

  context 'when end-to-end test using MockApis' do
    it 'can run end-to-end' do
      ENV['WEATHER_API_KEY'] = 'weather_api_key'
      return_successful_check('RH28HR')
      return_successful_weather('weather_api_key', 'RH2 8HR')
      pcaws = described_class.new.process('RH2       8HR')
      expect(pcaws).to eq('5.0')
    end
  end
end
