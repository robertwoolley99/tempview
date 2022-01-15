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
  end
end
