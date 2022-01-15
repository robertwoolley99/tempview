# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostCodeAndWeatherService do
  context 'when there is a problem' do
    it 'throws a fail if a nil is passed' do
      pcaws = described_class.new.process(nil)
      expect(pcaws).to eq('ERROR:NIL')
    end
    it 'throws a fail if there is no API key set' do
      ENV.delete('WEATHER_API_KEY')
      pcaws = described_class.new.process('RH2 8HR')
      expect(pcaws).to eq('ERROR:NO_API_KEY')
    end
  end
end
