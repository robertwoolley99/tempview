# frozen_string_literal: true

require 'rails_helper'
require 'temperature.rb'

RSpec.describe Temperature do
  describe 'current_temp method' do
    context 'when working with PCWS' do
      let(:pcaws) { instance_spy PostCodeAndWeatherService }

      it 'calls pcaws correctly' do
        allow(PostCodeAndWeatherService).to receive(:new).and_return(pcaws)
        temp = described_class.new
        temp.current_temp('RH2 8HR')
        expect(pcaws).to have_received(:process).with('RH2 8HR')
      end
    end
  end
end
