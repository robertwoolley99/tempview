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

    before { ENV['WEATHER_API_KEY'] = 'weather_api_key' }

    it 'returns an error if the postcode does not exist' do
      allow(PostCodeCheckerService).to receive(:new).and_return(pccs)
      allow(pccs).to receive(:check).and_return('NOT_VALID')
      pcaws = described_class.new.process('POSTCODE_NOT_EXISTING')
      expect(pcaws).to eq('POSTCODE_NOT_VALID')
    end
  end
end
