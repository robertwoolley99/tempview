# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostCodeAndWeatherService do
  context 'when there is a problem' do
    it 'throws a fail if a nil is passed' do
      pcaws = described_class.new.process(nil)
      expect(pcaws).to eq('NIL')
    end
  end
end
