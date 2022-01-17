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
      visit root_path
      fill_in 'temperature_max_temp', with: 40.0
      click_button('Update Maximum and Minimum Temperatures')
      expect(page).to have_field('temperature_max_temp', with: '40.0')
    end

    it 'updates min temp correctly' do
      visit root_path
      fill_in 'temperature_min_temp', with: -10.0
      click_button('Update Maximum and Minimum Temperatures')
      expect(page).to have_field('temperature_min_temp', with: '-10.0')
    end

    it 'tells us updates worked ok' do
      visit root_path
      fill_in 'temperature_min_temp', with: -10.0
      click_button('Update Maximum and Minimum Temperatures')
      expect(page).to have_content('Update completed.')
    end

    it 'rejects a max temp which is not higher than min temp' do
      visit root_path
      fill_in 'temperature_max_temp', with: 10
      click_button('Update Maximum and Minimum Temperatures')
      expect(page).to have_field('temperature_max_temp', with: '30.0')
    end

    it 'rejects a min temp which is not lower than max temp' do
      visit root_path
      fill_in 'temperature_min_temp', with: 90
      click_button('Update Maximum and Minimum Temperatures')
      expect(page).to have_field('temperature_min_temp', with: '20.0')
    end

    it 'tell us to ensure that the max temp is greater than the min temp' do
      visit root_path
      fill_in 'temperature_min_temp', with: 90
      click_button('Update Maximum and Minimum Temperatures')
      expect(page).to have_content('The minimum temperature must be less than the maximum temperature. Please try again.')
    end
  end
end
