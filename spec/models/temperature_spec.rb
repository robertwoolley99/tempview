# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Temperature do
  describe 'current_temp method' do
    context 'when working with PCWS' do
      let(:pcaws_spy) { instance_spy PostCodeAndWeatherService }

      it 'calls pcaws correctly' do
        allow(PostCodeAndWeatherService).to receive(:new).and_return(pcaws_spy)
        described_class.new.current_temp('RH2 8HR')
        expect(pcaws_spy).to have_received(:process).with('RH2 8HR')
      end
    end

    context 'when PCAWS returns errors correct text returned' do
      let(:pcaws_id) { instance_double PostCodeAndWeatherService}

      before { allow(PostCodeAndWeatherService).to receive(:new).and_return(pcaws_id) }

      it 'returns warning of incorrect postcode ' do
        allow(pcaws_id).to receive(:process).and_return({ status: 'invalid_postcode', postcode: 'BOGUS', temp: nil })
        output = described_class.new.current_temp('BOGUS_POSTCODE')
        expect(output).to eq("Sorry - that doesn't appear to be a valid UK postcode. Please try again.")

      end
    end
  end
end
