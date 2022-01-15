# frozen_string_literal: true

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe WeatherService do
  include MockApis::Weather
  context 'when correct requests are made' do
    it 'calls the correct URL' do
      return_successful_weather('1234', 'RH2 8HR')
      described_class.new.forecast('1234', 'RH2 8HR')
      expect(WebMock).to have_requested(:get, 'http://api.weatherapi.com/v1/current.json?key=1234&q=RH2 8HR')
    end

    it 'returns the correct temperature' do
      return_successful_weather('1234', 'RH2 8HR')
      output = described_class.new.forecast('1234', 'RH2 8HR')
      expect(output).to eq('5.0')
    end
  end

  context 'when there is a problem' do
    it 'cannot connect to the server' do
      weather_server_down('1234', 'RH2 8HR')
      output = described_class.new.forecast('1234', 'RH2 8HR')
      expect(output).to eq('FAIL')
    end

    it 'the server is up but there is another problem' do
      weather_server_up_but_broken('1234', 'RH2 8HR')
      output = described_class.new.forecast('1234', 'RH2 8HR')
      expect(output).to eq('FAIL')
    end
  end
end
