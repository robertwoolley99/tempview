# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Temperature Range', type: :feature do
  context 'when setting the max min ranges' do
    before do
      temp = Temperature.new
      temp.id = 1
      temp.min_temp = 20
      temp.max_temp = 30
      temp.save
    end

    it 'updates max temp correctly' do
      visit '/'
      fill_in 'temperature_max_temp', with: 30.0
      click_button('Update Maximum and Minimum Temperatures')
      expect(page).to have_field('temperature_max_temp', with: '30.0')
    end

    it 'updates min temp correctly' do
      visit '/'
      fill_in 'temperature_min_temp', with: -10.0
      click_button('Update Maximum and Minimum Temperatures')
      expect(page).to have_field('temperature_min_temp', with: '-10.0')
    end
  end
end
